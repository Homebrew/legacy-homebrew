require "formula"

class TomeeJaxRs < Formula
  desc "TomeEE Web Profile plus JAX-RS"
  homepage "http://tomee.apache.org/"
  url "http://www.apache.org/dyn/closer.cgi?path=tomee/tomee-1.7.1/apache-tomee-1.7.1-jaxrs.tar.gz"
  version "1.7.1"
  sha1 "5abce8176d034fefc19eb6c81fd5d64bc888d0a9"

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]

    # Install files
    prefix.install %w{ NOTICE LICENSE RELEASE-NOTES RUNNING.txt }
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/startup.sh" => "tomee-jax-rs-startup"
  end

  def caveats; <<-EOS.undent
    The home of Apache TomEE JAX-RS is:
      #{opt_libexec}
    To run Apache TomEE:
      #{opt_libexec}/bin/tomee-jax-rs-startup
    EOS
  end

  test do
    system "#{opt_libexec}/bin/configtest.sh"
  end
end
