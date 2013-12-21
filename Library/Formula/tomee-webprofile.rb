require 'formula'

class TomeeWebprofile < Formula
  homepage 'http://tomee.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=tomee/tomee-1.6.0/apache-tomee-1.6.0-webprofile.tar.gz'
  version '1.6.0'
  sha1 '7a13d9e3b3b66b7dd2f51ab3267f2709fc6e8424'

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
