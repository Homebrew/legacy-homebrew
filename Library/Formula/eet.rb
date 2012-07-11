require 'formula'

class Eet < Formula
  homepage 'http://trac.enlightenment.org/e/wiki/Eet'
  url 'http://download.enlightenment.org/releases/eet-1.5.0.tar.gz'
  sha1 '58a06c81027e4d85e5ced3260dde1faf4046b2ce'

  head 'http://svn.enlightenment.org/svn/e/trunk/eet/'

  if ARGV.build_head?
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'pkg-config' => :build
  depends_on 'eina'
  depends_on 'jpeg'
  depends_on 'lzlib'

  def install
    system "./autogen.sh" if ARGV.build_head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
