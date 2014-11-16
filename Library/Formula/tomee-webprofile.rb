require "formula"

class TomeeWebprofile < Formula
  homepage "http://tomee.apache.org/"
  url "http://www.apache.org/dyn/closer.cgi?path=tomee/tomee-1.7.1/apache-tomee-1.7.1-webprofile.tar.gz"
  version "1.7.1"
  sha1 "cc86efe41390e61247fd46706f84a9b011f1cd5e"

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]

    # Install files
    prefix.install %w{ NOTICE LICENSE RELEASE-NOTES RUNNING.txt }
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
