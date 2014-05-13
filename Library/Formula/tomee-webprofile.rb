require 'formula'

class TomeeWebprofile < Formula
  homepage 'http://tomee.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=tomee/tomee-1.6.0.1/apache-tomee-1.6.0.1-webprofile.tar.gz'
  version '1.6.0.1'
  sha1 'e9dc8d814ccee49c48bd2f077474ed312cac226d'

  # Keep log folders
  skip_clean 'libexec'

  def install
    # Remove Windows scripts
    rm_rf Dir['bin/*.bat']

    # Install files
    prefix.install %w{ NOTICE LICENSE RELEASE-NOTES RUNNING.txt }
    libexec.install Dir['*']
    bin.install_symlink "#{libexec}/bin/startup.sh" => "tomee-webprofile-startup"
  end
end
