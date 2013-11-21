require 'formula'

class Eina < Formula
  homepage 'http://trac.enlightenment.org/e/wiki/Eina'
  url 'http://download.enlightenment.org/releases/eina-1.7.9.tar.gz'
  sha1 '26f385e888b29876c8fb06f35f0433ab7e3251d5'

  head do
    url 'http://svn.enlightenment.org/svn/e/trunk/eina/'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'pkg-config' => :build

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
