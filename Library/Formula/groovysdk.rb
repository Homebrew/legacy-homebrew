require "formula"

class Groovysdk < Formula
  homepage "http://groovy.codehaus.org/"
  url "http://dl.bintray.com/groovy/maven/groovy-sdk-2.4.0.zip"
  sha1 "b6f4bdb48c306e8d47a552f835fd56fb6010e941"

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
