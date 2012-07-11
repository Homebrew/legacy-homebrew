require 'formula'

class Eina < Formula
  homepage 'http://trac.enlightenment.org/e/wiki/Eina'
  url 'http://download.enlightenment.org/releases/eina-1.1.0.tar.gz'
  sha1 'b9dbfda79d0cc9cdc28a4a87125d339688bb65a4'

  head 'http://svn.enlightenment.org/svn/e/trunk/eina/'

  if ARGV.build_head?
    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'pkg-config' => :build

  def install
    system "./autogen.sh" if ARGV.build_head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
