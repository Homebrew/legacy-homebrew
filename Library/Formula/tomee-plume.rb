class TomeePlume < Formula
  desc "Apache TomEE Plume"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomee/tomee-1.7.2/apache-tomee-1.7.2-plume.tar.gz"
  version "1.7.2"
  sha256 "7e6c67a19c6f0cc352e6a107fdf7ee1908eda6e4bfbdcc6d43dcf984de360508"

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]
    rm_rf Dir["bin/*.bat.original"]
    rm_rf Dir["bin/*.exe"]

    # Install files
    prefix.install %w[NOTICE LICENSE RELEASE-NOTES RUNNING.txt]
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
