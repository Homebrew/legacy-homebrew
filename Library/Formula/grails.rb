class Grails < Formula
  desc "Web application framework for the Groovy language"
  homepage "https://grails.org"
  url "https://github.com/grails/grails-core/releases/download/v3.0.4/grails-3.0.4.zip"
  sha256 "7fa8581a200e532c4701e1d56fc12305872369d520d3a7e624608f4dae87a4e4"

  def install
    rm_f Dir["bin/*.bat", "bin/cygrails", "*.bat"]
    prefix.install_metafiles
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats; <<-EOS.undent
    The GRAILS_HOME directory is:
      #{opt_libexec}
    EOS
  end

  test do
    assert_match /Application created/, shell_output("#{bin}/grails create-app testApp")
  end
end
