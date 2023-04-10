require "json"
require "yaml"

module Snyk
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
      orange = Colorize::Color256.new(208)
      string.upcase.colorize({
        "low":      :green,
        "medium":   :yellow,
        "high":     orange,
        "critical": :red,
      }.fetch(string, :default)).to_s
    end

    def sort_index
      {
        "low":      4,
        "medium":   3,
        "high":     2,
        "critical": 1,
      }.fetch(@severity, 4)
    end
  end

  class Result
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
end
