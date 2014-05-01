require 'formula'

class TomeeJaxRs < Formula
  homepage 'http://tomee.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=tomee/tomee-1.6.0.1/apache-tomee-1.6.0.1-jaxrs.tar.gz'
  version '1.6.0.1'
  sha1 '4b4f11a12f8f9b23ea7dfd2a8a90c861bf65fb1d'

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
