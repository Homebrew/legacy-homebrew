require "formula"

class ApacheKaraf < Formula
  homepage "http://karaf.apache.org"
  url "http://www.apache.org/dyn/closer.cgi?path=karaf/2.3.6/apache-karaf-2.3.6.tar.gz"
  sha1 "9a54171ade3c3722a8385b916d9904038af8c13d"

  def install
    libexec.install "bin", "data", "demos", "deploy", "etc", "lib", "system"
  end

  test do
    system libexec/"bin/admin"
  end
end
