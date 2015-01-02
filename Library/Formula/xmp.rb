class Xmp < Formula
  homepage "http://xmp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/xmp/xmp/4.0.10/xmp-4.0.10.tar.gz"
  sha1 "e6a39a5158a9e36d437b233d68a8dc7756a971e1"

  bottle do
    sha1 "f9b3c62d4952cd0ede1c131dcdf973903316d87d" => :mavericks
    sha1 "6adf877d9f4cd3c1b96da42f806724a9801ca311" => :mountain_lion
    sha1 "4ad77815e84f8251d2c06fc72fa5ecfbf0447b19" => :lion
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
