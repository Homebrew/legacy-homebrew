require "formula"

class Osslsigncode < Formula
  homepage "http://sourceforge.net/projects/osslsigncode/"
  url "https://downloads.sourceforge.net/project/osslsigncode/osslsigncode/osslsigncode-1.6.tar.gz"
  sha1 "83c169638c8c1e0122127674cbb73d2e0e6b5bc2"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha1 "343585fea99f289ae65a66297cb644fb96ec5c89" => :mavericks
    sha1 "93a53082b119c7facf8e5b59ede70d0756f72eb9" => :mountain_lion
    sha1 "aabd093edd467aa6804c4e52ac0f5fb95359c6c3" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "libgsf" => :optional

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
