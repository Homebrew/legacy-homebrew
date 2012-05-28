require 'formula'

class Eet < Formula
  homepage 'http://trac.enlightenment.org/e/wiki/Eet'
  url 'http://download.enlightenment.org/releases/eet-1.5.0.tar.gz'
  md5 'f6fd734fbf6a2852abf044a2e1a8cabf'

  head 'http://svn.enlightenment.org/svn/e/trunk/eet/'

  depends_on 'pkg-config' => :build
  depends_on 'eina'
  depends_on 'jpeg'
  depends_on 'lzlib'

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
