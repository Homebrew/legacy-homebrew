require "formula"

class TomeePlus < Formula
  homepage "http://tomee.apache.org/"
  url "http://www.apache.org/dyn/closer.cgi?path=tomee/tomee-1.7.1/apache-tomee-1.7.1-plus.tar.gz"
  version "1.7.1"
  sha1 "c957652b205ec2395dfc30004e88088d4fb41aa5"

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]

    # Install files
    prefix.install %w{ NOTICE LICENSE RELEASE-NOTES RUNNING.txt }
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/startup.sh" => "tomee-plus-startup"
  end

  def caveats; <<-EOS.undent
    The home of Apache TomEE Plus is:
      #{opt_libexec}
    To run Apache TomEE:
      #{opt_libexec}/bin/tomee-plus-startup
    EOS
  end

  test do
    system "#{opt_libexec}/bin/configtest.sh"
  end
end
