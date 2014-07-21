require 'formula'

class TomeePlus < Formula
  homepage 'http://tomee.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=tomee/tomee-1.6.0.2/apache-tomee-1.6.0.2-plus.tar.gz'
  version '1.6.0.2'
  sha1 '11b605f2da94fbc2bc571e62578c1599c2a4a789'

  # Keep log folders
  skip_clean 'libexec'

  def install
    # Remove Windows scripts
    rm_rf Dir['bin/*.bat']

    # Install files
    prefix.install %w{ NOTICE LICENSE RELEASE-NOTES RUNNING.txt }
    libexec.install Dir['*']
    bin.install_symlink "#{libexec}/bin/startup.sh" => "tomee-plus-startup"
  end
end
