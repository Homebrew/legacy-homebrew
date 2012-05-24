require 'formula'

class Embryo < Formula
  homepage 'http://trac.enlightenment.org/e/wiki/Embryo'
  url 'http://download.enlightenment.org/releases/embryo-1.1.0.tar.gz'
  md5 'aded5754ee7f586e3a0631e0fa3abcc8'

  head 'http://svn.enlightenment.org/svn/e/trunk/embryo/'

  depends_on 'pkg-config' => :build
  depends_on 'eina'

  if ARGV.build_head? and MacOS.xcode_version >= "4.3"
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen.sh" if ARGV.build_head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
