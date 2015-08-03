class TomeeJaxRs < Formula
  desc "TomeEE Web Profile plus JAX-RS"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomee/tomee-1.7.1/apache-tomee-1.7.1-jaxrs.tar.gz"
  version "1.7.1"
  sha256 "c7903f30d072037ebf94d81c1326a91a17e357e6e8dba86d2f3b0e20e59a27a8"

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]

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
