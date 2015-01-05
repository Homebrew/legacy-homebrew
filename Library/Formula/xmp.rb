class Xmp < Formula
  homepage "http://xmp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/xmp/xmp/4.0.10/xmp-4.0.10.tar.gz"
  sha1 "e6a39a5158a9e36d437b233d68a8dc7756a971e1"

  bottle do
    sha1 "fb720ca09235acac04666f9661eb106717450f11" => :yosemite
    sha1 "141425e9760daeb055ee61829ed2ffcf7a20b65a" => :mavericks
    sha1 "4bcc80d2356c0a89f291d592c711c449882d8254" => :mountain_lion
  end

  head do
    url "git://git.code.sf.net/p/xmp/xmp-cli"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libxmp"

  def install
    if build.head?
      system "glibtoolize"
      system "aclocal"
      system "autoconf"
      system "automake", "--add-missing"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
