require 'formula'

class TomeeWebprofile < Formula
  homepage 'http://tomee.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=tomee/tomee-1.6.0.2/apache-tomee-1.6.0.2-webprofile.tar.gz'
  version '1.6.0.2'
  sha1 'd68cdc7a21c8e2286140fc8e73c4192a3018c018'

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
