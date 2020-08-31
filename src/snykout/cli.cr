require "json"
require "yaml"
require "colorize"

require "commander"
require "tallboy"

class Vulnerability
  include JSON::Serializable
  include YAML::Serializable
  property id : String
  property title : String
  property name : String
  property version : String
  property severity : String
  property description : String
  @[JSON::Field(key: "packageName")]
  property package_name : String?
  @[YAML::Field(key: "cvssScore")]
  @[JSON::Field(key: "cvssScore")]
  property cvss_score : Float32?
  @[JSON::Field(key: "CVSSv3")]
  property cvss_v3 : String?
  @[JSON::Field(key: "dockerBaseImage")]
  property base_image : String?
  @[JSON::Field(key: "dockerfileInstruction")]
  property? dockerfile_instruction : String?

  @[JSON::Field(key: "nearestFixedInVersion")]
  property? fixed_in_version : String?

  property identifiers : Hash(String, Array(String))?

  getter type : String?
  getter fixed_in : String?
  getter cvss : String?
  getter cve : String?
  getter cwe : Array(String)?

  def add_properties!(type : String)
    @package = @package_name
    @cvss = @cvss_v3
    @source = @dockerfile_instruction ? nil : @base_image
    @type = type

    @fixed_in = @fixed_in_version

    @cwe = get_cwe(@identifiers)
    @cve = get_cve(@identifiers)

    @package_name = @cvss_v3 = @base_image = @dockerfile_instruction = @identifiers = @fixed_in_version = nil
  end

  def get_cwe(idents : (Hash(String, Array(String)) | Nil))
    idents ? idents.fetch("CWE", nil) : nil
  end

  def get_cve(idents : (Hash(String, Array(String)) | Nil))
    cves = idents ? idents.fetch("CVE", nil) : nil
    cves ? cves.first : nil
  end

  def cve_or_id
    @cve || @id
  end

  def cwe_list(cwes : (Array(String) | Nil))
    cwes ? cwes.join(",") : nil
  end

  def source?
    @source
  end

  def summary
    @title
  end

  def self.color(string : String)
    string.upcase.colorize({
      "low":    :green,
      "medium": :yellow,
      "high":   :red,
    }.fetch(string, :default)).to_s
  end

  def sort_index
    {
      "low":    3,
      "medium": 2,
      "high":   1,
    }.fetch(@severity, 4)
  end
end

class SnykResult
  include JSON::Serializable
  include YAML::Serializable
  property vulnerabilities : Array(Vulnerability)
  property ok : Bool
  property org : String
  @[YAML::Field(key: "dependencyCount")]
  @[JSON::Field(key: "dependencyCount")]
  property dependency_count : Int32
  @[JSON::Field(key: "uniqueCount")]
  property unique_count : Int32

  property project : String?
  @[YAML::Field(key: "baseImage")]
  @[JSON::Field(key: "baseImage")]
  property base_image : String?
end

module SnykOut::CLI
  extend self

  def render_table(message, data, markdown, wide)
    filtered_data = data.uniq { |vuln| vuln.id }.sort_by { |vuln| {vuln.sort_index, vuln.name} }
    table = wide ? wide_vulnerability_table(message, filtered_data) : vulnerability_table(message, filtered_data)
    markdown ? table.render(:markdown).to_s : table.render(:ascii).to_s
  end

  def vulnerability_table(message, data)
    row_data = data.map { |vuln| [vuln.name, Vulnerability.color(vuln.severity), vuln.cve_or_id, vuln.title, vuln.version, vuln.fixed_in] }

    Tallboy.table do
      columns do
        add "Package"
        add "Severity"
        add "ID"
        add "Issue"
        add "Installed"
        add "Fixed in"
      end
      header message
      header
      rows row_data
    end
  end

  def wide_vulnerability_table(message, data)
    row_data = data.map { |vuln|
      [vuln.name, Vulnerability.color(vuln.severity), vuln.cve_or_id, vuln.title, vuln.version, vuln.fixed_in, vuln.cvss_score, vuln.cvss, vuln.cwe_list(vuln.cwe)]
    }

    Tallboy.table do
      columns do
        add "Package"
        add "Severity"
        add "ID"
        add "Issue"
        add "Installed"
        add "Fixed in"
        add "CVSS Score"
        add "CVSS"
        add "CWE"
      end
      header message
      header
      rows row_data
    end
  end

  def config # ameba:disable Metrics/CyclomaticComplexity
    Commander::Command.new do |cmd|
      cmd.use = "snykout"
      cmd.long = "Show vulnerability information from Snyk test output"

      cmd.run do |options, arguments|
        if arguments.empty?
          puts cmd.help
          exit 0
        end

        begin
          input = arguments.first == "-" ? STDIN.gets_to_end : File.read(arguments.first)
        rescue ex : File::Error
          puts ex.message.colorize(:red)
          exit 2
        end

        begin
          result = SnykResult.from_json(input)
          json = JSON.parse(input)
        rescue ex : JSON::ParseException
          puts "#{arguments.first} contains invalid JSON".colorize(:red)
          puts ex.message
          exit 2
        end

        result.project = json["projectName"].to_s.gsub("docker-image|", "")
        result.base_image = json["docker"]["baseImage"].to_s rescue KeyError
        result.vulnerabilities.each { |vuln| vuln.add_properties!(json["packageManager"].as_s) }

        output = "test"

        if options.bool["json"]
          output = options.bool["pretty"] ? result.to_pretty_json : result.to_json
        elsif options.bool["yaml"]
          output = result.to_yaml
        else
          output = render_table("Found #{result.unique_count} unique vulnerabiliies for #{result.project.colorize.bright}", result.vulnerabilities.select { |vuln| !vuln.source? }, options.bool["markdown"], options.bool["wide"])

          output = output + "\n\n" + render_table("Base image vulnerabilities from #{result.base_image.colorize.bright}", result.vulnerabilities.select { |vuln| vuln.source? }, options.bool["markdown"], options.bool["wide"]) if result.base_image
        end

        if options.string["output"] == "stdout"
          puts output
        else
          begin
            File.write(options.string["output"], output.to_s)
          rescue ex : File::Error
            puts ex.message.colorize(:red)
            exit 2
          end
        end

        result.ok ? exit 0 : exit 1
      end

      cmd.flags.add do |flag|
        flag.name = "json"
        flag.long = "--json"
        flag.default = false
        flag.description = "Output results as JSON"
      end

      cmd.flags.add do |flag|
        flag.name = "yaml"
        flag.long = "--yaml"
        flag.default = false
        flag.description = "Output results as YAML"
      end

      cmd.flags.add do |flag|
        flag.name = "pretty"
        flag.long = "--pretty"
        flag.default = false
        flag.description = "Make JSON results more human readable"
      end

      cmd.flags.add do |flag|
        flag.name = "markdown"
        flag.long = "--markdown"
        flag.default = false
        flag.description = "Output results as Markdown"
      end

      cmd.flags.add do |flag|
        flag.name = "wide"
        flag.long = "--wide"
        flag.default = false
        flag.description = "Output additional information in the table"
      end

      cmd.flags.add do |flag|
        flag.name = "output"
        flag.short = "-o"
        flag.long = "--output FILE"
        flag.default = "stdout"
        flag.description = "Output results as JSON"
      end
    end
  end

  def run(argv)
    Commander.run(config, argv)
  end
end
