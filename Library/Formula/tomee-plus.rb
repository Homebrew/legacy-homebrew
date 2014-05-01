require 'formula'

class TomeePlus < Formula
  homepage 'http://tomee.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=tomee/tomee-1.6.0.1/apache-tomee-1.6.0.1-plus.tar.gz'
  version '1.6.0.1'
  sha1 'a9d47bb3eff81440586ec26613c11a2e164c6d04'

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
