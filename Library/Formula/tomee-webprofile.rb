class TomeeWebprofile < Formula
  desc "All-Apache Java EE 6 Web Profile stack"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomee/tomee-1.7.1/apache-tomee-1.7.1-webprofile.tar.gz"
  version "1.7.1"
  sha256 "5364e583f8e7838cd5671ee0354b106351bc63aef665bb7ee1e3c746f01bb62a"

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]

    # Install files
    prefix.install %w[NOTICE LICENSE RELEASE-NOTES RUNNING.txt]
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/startup.sh" => "tomee-webprofile-startup"
  end

  def caveats; <<-EOS.undent
    The home of Apache TomEE Web is:
      #{opt_libexec}
    To run Apache TomEE:
      #{opt_libexec}/bin/tomee-webprofile-startup
    EOS
  end

  test do
    system "#{opt_libexec}/bin/configtest.sh"
  end
end
