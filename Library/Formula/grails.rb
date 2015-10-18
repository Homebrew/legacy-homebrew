class Grails < Formula
  desc "Web application framework for the Groovy language"
  homepage "https://grails.org"
  url "https://github.com/grails/grails-core/releases/download/v3.0.7/grails-3.0.7.zip"
  sha256 "d99b11e4a8fb1f5a155f1784f482316df96e63d094d5d083a62bc37905380800"

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
    output = shell_output("#{bin}/grails --version")
    assert_match /Grails Version: #{version}/, output
  end
end
