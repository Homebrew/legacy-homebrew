require 'formula'

class TomeeWebprofile < Formula
  homepage 'http://tomee.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=tomee/tomee-1.5.2/apache-tomee-1.5.2-webprofile.tar.gz'
  version '1.5.2'
  sha1 '04973507937ab01c78263ff0209851c4cc30cea6'

  # Keep log folders
  skip_clean 'libexec'

  def install
    # Remove Windows scripts
    rm_rf Dir['bin/*.bat']

    # Install files
    prefix.install %w{ NOTICE LICENSE RELEASE-NOTES RUNNING.txt }
    libexec.install Dir['*']
    bin.install_symlink "#{libexec}/bin/tomee.sh" => "tomee-webprofile"
  end
end
