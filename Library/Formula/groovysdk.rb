require "formula"

class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "http://groovy.codehaus.org/"
  url "http://dl.bintray.com/groovy/maven/groovy-sdk-2.4.3.zip"
  sha1 "a3aa1161422132dc116f8b8171914b36668b3839"

  def install
    ENV["GROOVY_HOME"] = libexec

    # We don't need Windows' files.
    rm_f Dir["bin/*.bat"]

    prefix.install_metafiles
    bin.install Dir["bin/*"]
    libexec.install %w(conf lib embeddable src doc)
    bin.env_script_all_files(libexec+"bin", :GROOVY_HOME => ENV["GROOVY_HOME"])
  end

  test do
    system "#{bin}/grape", "install", "org.activiti", "activiti-engine", "5.16.4"
  end
end
