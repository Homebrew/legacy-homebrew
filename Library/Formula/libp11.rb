require 'formula'

class Libp11 < Formula
  homepage 'https://github.com/OpenSC/libp11/wiki'
  url 'https://downloads.sourceforge.net/project/opensc/libp11/libp11-0.2.8.tar.gz'
  sha1 '2d1f6dc4200038f55a0cb7e22858f93e484b0724'

  head do
    url 'https://github.com/OpenSC/libp11.git'
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libtool" => :run

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
