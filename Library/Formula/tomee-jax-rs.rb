class TomeeJaxRs < Formula
  desc "TomeEE Web Profile plus JAX-RS"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomee/tomee-1.7.3/apache-tomee-1.7.3-jaxrs.tar.gz"
  version "1.7.3"
  sha256 "5a79578d02b5d2896f416f04592e5b48b036b297cb4e25717a1fe61249dbc877"

  bottle :unneeded

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]
    rm_rf Dir["bin/*.bat.original"]
    rm_rf Dir["bin/*.exe"]

    # Install files
    prefix.install %w[NOTICE LICENSE RELEASE-NOTES RUNNING.txt]
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
