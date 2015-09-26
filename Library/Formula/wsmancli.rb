class Wsmancli < Formula
  desc "Openwsman command-line client"
  homepage "https://github.com/Openwsman/wsmancli"
  url "https://github.com/Openwsman/wsmancli/archive/v2.3.1.tar.gz"
  sha256 "f8e71b842c506885f63d80d7cd49bb95989043b1305b95c1fbda27ca2df9528b"

  bottle do
    cellar :any
    sha1 "d6e54b66cf4e0f18f69805cb762015739954c56c" => :yosemite
    sha1 "e8c5852a0e3fe97db973b90c676c779177b2d0ca" => :mavericks
    sha1 "cafa52a3f52158c65f36f05f550f525c2ddcfa12" => :mountain_lion
  end

  depends_on "openwsman"
  depends_on "autoconf"   => :build
  depends_on "automake"   => :build
  depends_on "libtool"    => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/wsman", "-q"
  end
end
