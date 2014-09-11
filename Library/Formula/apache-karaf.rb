require "formula"

class ApacheKaraf < Formula
  homepage "http://karaf.apache.org"
  url "http://www.apache.org/dyn/closer.cgi?path=karaf/2.3.6/apache-karaf-2.3.6.tar.gz"
  sha1 "9a54171ade3c3722a8385b916d9904038af8c13d"

  def install
    libexec.install "bin", "data", "demos", "deploy", "etc", "lib", "system"

    bin.install_symlink "#{libexec}/bin/admin" => "karaf-admin"
    bin.install_symlink "#{libexec}/bin/client" => "karaf-client"
    bin.install_symlink "#{libexec}/bin/karaf" => "karaf"
    bin.install_symlink "#{libexec}/bin/start" => "karaf-start"
    bin.install_symlink "#{libexec}/bin/status" => "karaf-status"
    bin.install_symlink "#{libexec}/bin/stop" => "karaf-stop"
  end

  test do
    system libexec/"bin/admin"
  end
end
