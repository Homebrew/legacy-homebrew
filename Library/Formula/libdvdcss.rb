class Libdvdcss < Formula
  desc "Access DVDs as block devices without the decryption"
  homepage "https://www.videolan.org/developers/libdvdcss.html"
  url "https://download.videolan.org/pub/videolan/libdvdcss/1.4.0/libdvdcss-1.4.0.tar.bz2"
  sha256 "2089375984800df29a4817b37f3123c1706723342d6dab4d0a8b75c25c2c845a"

  bottle do
    cellar :any
    sha256 "f833ab30a591de897cab74d05cb35cd2017af23311431229f98af23f539a63d1" => :el_capitan
    sha256 "612ee99696b4bfa8a9fa8e7d0f57f391a6c4ff678116ad670a860e82145a171a" => :yosemite
    sha256 "17b3292cb7d2f2055ab411e2eb9667337808e505ba12cf8c6386626d70b75d2e" => :mavericks
  end

  head do
    url "git://git.videolan.org/libdvdcss"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "-if" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end
end
