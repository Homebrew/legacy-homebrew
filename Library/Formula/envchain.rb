class Envchain < Formula
  desc "Secure your credentials in environment variables"
  homepage "https://github.com/sorah/envchain"
  head "https://github.com/sorah/envchain.git"
  url "https://github.com/sorah/envchain/archive/v0.2.0.tar.gz"
  sha256 "2a863688d1e0bdc47ba8339f57c8b5e22f5002fd3ab58928766e45f23c6ca267"

  bottle do
    cellar :any
    sha256 "7c56a78978b405c920c1278dd8e84622087bdee5d91a73aaaa7b1757b474c442" => :yosemite
    sha256 "94f45f2adb511adeb57be4cb517ef169ae2205b0edb7053d71d0b63d8a2d8a6d" => :mavericks
    sha256 "87b6a0fa82f1702f8b9d911f22c3cd322f63824cb37c3fecfb697c7ae98ed243" => :mountain_lion
  end

  def install
    system "make", "DESTDIR=#{prefix}", "install"
  end

  test do
    assert_match /envchain version #{version}/, shell_output("#{bin}/envchain 2>&1", 2)
  end
end
