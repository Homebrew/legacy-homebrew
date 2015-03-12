module Language
  module Java
    def self.java_home_env(version=nil)
      version_flag = " --version #{version}" if version
      java_home = "$(/usr/libexec/java_home#{version_flag})"
      { :JAVA_HOME => "$(if [ -z \"$JAVA_HOME\" ]; then echo \"#{java_home}\"; else echo \"$JAVA_HOME\"; fi)" }
    end
  end
end
