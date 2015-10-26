class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "http://www.groovy-lang.org"
  url "https://dl.bintray.com/groovy/maven/apache-groovy-sdk-2.4.5.zip"
  sha256 "48d9f7f1165c12f7eed2b9a762820a7ffe176b666b1605c9b1411ab3b3f45a1d"

  bottle :unneeded

  def install
    ENV["GROOVY_HOME"] = libexec

    # We don't need Windows' files.
    rm_f Dir["bin/*.bat"]

    prefix.install_metafiles
    bin.install Dir["bin/*"]
    libexec.install %w[conf lib embeddable src doc]
    bin.env_script_all_files(libexec+"bin", :GROOVY_HOME => ENV["GROOVY_HOME"])
  end

  test do
    system "#{bin}/grape", "install", "org.activiti", "activiti-engine", "5.16.4"
  end
end
