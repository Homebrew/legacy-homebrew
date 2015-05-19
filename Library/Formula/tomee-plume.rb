require "formula"

class TomeePlume < Formula
  desc "Apache TomEE Plume"
  homepage "http://tomee.apache.org/"
  url "http://www.apache.org/dyn/closer.cgi?path=tomee/tomee-1.7.1/apache-tomee-1.7.1-plume.tar.gz"
  version "1.7.1"
  sha1 "b27386dd16df4cc936283dd3739012a5eed3224a"

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]

    # Install files
    prefix.install %w{ NOTICE LICENSE RELEASE-NOTES RUNNING.txt }
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/startup.sh" => "tomee-plume-startup"
  end

  def caveats; <<-EOS.undent
    The home of Apache TomEE Plume is:
      #{opt_libexec}
    To run Apache TomEE:
      #{opt_libexec}/bin/tomee-plume-startup
    EOS
  end

  test do
    system "#{opt_libexec}/bin/configtest.sh"
  end
end
