require 'formula'

class Eina < Formula
  homepage 'http://trac.enlightenment.org/e/wiki/Eina'
  url 'http://download.enlightenment.org/releases/eina-1.2.1.tar.gz'
  sha1 '6a96fe66cdfc26681a38d5d666898fc3e7ab7cbe'

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
