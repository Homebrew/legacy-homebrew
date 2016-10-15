require 'formula'

class TomeeJaxRs < Formula
  homepage 'http://tomee.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=tomee/tomee-1.6.0/apache-tomee-1.6.0-jaxrs.tar.gz'
  version '1.6.0'
  sha1 '1db7d705012f891e9ba7d6487be4fe93ea794ffb'

  # Keep log folders
  skip_clean 'libexec'

  def install
    # Remove Windows scripts
    rm_rf Dir['bin/*.bat']

    # Install files
    prefix.install %w{ NOTICE LICENSE RELEASE-NOTES RUNNING.txt }
    libexec.install Dir['*']
    bin.install_symlink "#{libexec}/bin/tomee.sh" => "tomee-jax-rs"
  end
end
