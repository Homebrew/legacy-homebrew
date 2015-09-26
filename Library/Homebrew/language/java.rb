module Language
  module Java
    def self.java_home_cmd(version = nil)
      version_flag = " --version #{version}" if version
      "/usr/libexec/java_home#{version_flag}"
    end

    def self.java_home_env(version = nil)
      { :JAVA_HOME => "$(#{java_home_cmd(version)})" }
    end

    def self.overridable_java_home_env(version = nil)
      { :JAVA_HOME => "${JAVA_HOME:-$(#{java_home_cmd(version)})}" }
    end
  end
end
