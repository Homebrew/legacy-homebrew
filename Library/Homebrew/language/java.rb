module Language
  module Java
    def self.java_home_env(version=nil)
      version_flag = " --version #{version}" if version
      { :JAVA_HOME => "$(/usr/libexec/java_home#{version_flag})" }
    end
  end
end
