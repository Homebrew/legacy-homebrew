require 'formula'

class Libaacs < Formula
  homepage 'http://www.videolan.org/developers/libaacs.html'
  url 'ftp://ftp.videolan.org/pub/videolan/libaacs/0.7.0/libaacs-0.7.0.tar.bz2'
  sha1 '461c0a6f143519cd6b24bf4be5e2672219b44780'
  revision 1

  bottle do
    cellar :any
    sha1 "55c20042708796483b4e46af4825fff708bd6bdb" => :mavericks
    sha1 "538f3413ca66af218def8fec70414de82315a2f2" => :mountain_lion
    sha1 "ec113ed356983ea28c0f0d656d3964a50c4e7653" => :lion
  end

  head do
    url 'git://git.videolan.org/libaacs.git'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on 'bison' => :build
  depends_on 'libgcrypt'

  def install
    system './bootstrap' if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
