require 'formula'

class TomeeJaxRs < Formula
  homepage 'http://tomee.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=tomee/tomee-1.6.0.2/apache-tomee-1.6.0.2-jaxrs.tar.gz'
  version '1.6.0.2'
  sha1 '53e438f72edb455f4d01464d2e00855fa055ad6b'

  # Keep log folders
  skip_clean 'libexec'

  def install
    # Remove Windows scripts
    rm_rf Dir['bin/*.bat']

    # Install files
    prefix.install %w{ NOTICE LICENSE RELEASE-NOTES RUNNING.txt }
    libexec.install Dir['*']
    bin.install_symlink "#{libexec}/bin/startup.sh" => "tomee-jax-rs-startup"
  end
end
