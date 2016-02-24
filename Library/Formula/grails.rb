class Grails < Formula
  desc "Web application framework for the Groovy language"
  homepage "https://grails.org"
  url "https://github.com/grails/grails-core/releases/download/v3.1.1/grails-3.1.1.zip"
  sha256 "0c85f55d70a9dabb435d995ee0e2359d313de9f8d0851aeac46280cf3f054d1b"

  bottle :unneeded

  def install
    rm_f Dir["bin/*.bat", "bin/cygrails", "*.bat"]
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats; <<-EOS.undent
    The GRAILS_HOME directory is:
      #{opt_libexec}
    EOS
  end

  test do
    output = shell_output("#{bin}/grails --version")
    assert_match /Grails Version: #{version}/, output
  end
end
