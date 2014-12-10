require 'formula'

class Libp11 < Formula
  homepage 'https://github.com/OpenSC/libp11/wiki'
  url 'https://downloads.sourceforge.net/project/opensc/libp11/libp11-0.2.8.tar.gz'
  sha1 '2d1f6dc4200038f55a0cb7e22858f93e484b0724'

  bottle do
    cellar :any
    revision 1
    sha1 "fc0e0c6804dec4fceb529cefa3a8e756b3cc0633" => :yosemite
    sha1 "3e955e07a8981bd543283ca58c9698e5cdf163d0" => :mavericks
    sha1 "c6b65a79de96ef4185e1582a7b5fca98827efde1" => :mountain_lion
  end

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
