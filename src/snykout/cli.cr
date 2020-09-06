require "colorize"

require "commander"
require "tallboy"

require "../snyk"

module SnykOut::CLI
  extend self

  def render_table(message, data, markdown, wide)
    filtered_data = data.uniq { |vuln| vuln.id }.sort_by { |vuln| {vuln.sort_index, vuln.name} }
    table = wide ? wide_vulnerability_table(message, filtered_data) : vulnerability_table(message, filtered_data)
    markdown ? table.render(:markdown).to_s : table.render(:ascii).to_s
  end

  def vulnerability_table(message, data)
    row_data = data.map { |vuln| [vuln.name, Snyk::Vulnerability.color(vuln.severity), vuln.cve_or_id, vuln.title, vuln.version, vuln.fixed_in] }

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
      [vuln.name, Snyk::Vulnerability.color(vuln.severity), vuln.cve_or_id, vuln.title, vuln.version, vuln.fixed_in, vuln.cvss_score, vuln.cvss, vuln.cwe_list(vuln.cwe)]
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
          result = Snyk::Result.from_json(input)
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

      [
        {"json", "Output results as JSON"},
        {"yaml", "Output results as YAML"},
        {"pretty", "Make JSON results more human readable"},
        {"markdown", "Output results as markdown"},
        {"wide", "Output additional information"},
      ].each do |name, description|
          cmd.flags.add do |flag|
            flag.name = name
            flag.long = "--#{name}"
            flag.default = false
            flag.description = description
          end
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
