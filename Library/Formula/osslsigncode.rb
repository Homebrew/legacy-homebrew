class Osslsigncode < Formula
  homepage "https://sourceforge.net/projects/osslsigncode/"
  url "https://downloads.sourceforge.net/project/osslsigncode/osslsigncode/osslsigncode-1.7.1.tar.gz"
  sha256 "f9a8cdb38b9c309326764ebc937cba1523a3a751a7ab05df3ecc99d18ae466c9"

  bottle do
    cellar :any
    revision 1
    sha1 "343585fea99f289ae65a66297cb644fb96ec5c89" => :mavericks
    sha1 "93a53082b119c7facf8e5b59ede70d0756f72eb9" => :mountain_lion
    sha1 "aabd093edd467aa6804c4e52ac0f5fb95359c6c3" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "openssl"
  depends_on "libgsf" => :optional

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
