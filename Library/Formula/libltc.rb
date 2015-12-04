class Libltc < Formula
  desc "POSIX-C Library for handling Linear/Logitudinal Time Code (LTC)"
  homepage "https://x42.github.io/libltc/"
  url "https://github.com/x42/libltc/releases/download/v1.1.4/libltc-1.1.4.tar.gz"
  sha256 "7d9c43601190b2702de03080cf9cd1c314c523b09d19aa4ac0d08610d7075a75"

  bottle do
    cellar :any
    revision 1
    sha256 "d564cdf6f1790cf144426fb2e3adb8e3a5caa9b519f4fa72a994ee416f118ba3" => :yosemite
    sha256 "f29db88c6858b07e9273974a8c4633bd2ceb302ba033c41cfe31f171fa02c9d0" => :mavericks
    sha256 "a3e44438c81e84aa4bfb3e1e86190cd4f8271d490a9ee7cea64ecd18936e070e" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
