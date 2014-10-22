require "formula"

class Groovysdk < Formula
  homepage "http://groovy.codehaus.org/"
  url "http://dl.bintray.com/groovy/maven/groovy-sdk-2.3.7.zip"
  sha1 "a9021d36b5626692d2ab56b2799add8aadcd9ca2"

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
