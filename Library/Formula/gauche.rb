require 'formula'

class Gauche <Formula
  url 'http://downloads.sourceforge.net/gauche/Gauche-0.9.tgz'
  homepage 'http://practical-scheme.net/gauche/index.html'
  head 'http://gauche.svn.sourceforge.net/svnroot/gauche/Gauche/trunk', :using => :svn
  md5 '1ab7e09da8436950989efd55b5dc270a'

  depends_on 'gdbm'
  depends_on 'slib' => :optional

  def install
    system "./DIST gen" if ARGV.build_head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}", "--infodir=#{info}",
                          "--with-slib=#{HOMEBREW_PREFIX}/lib/slib",
                          "--enable-multibyte=utf-8", "--enable-threads=pthreads",
                          "--enable-ipv6"
    system "make"
    system "make check"
    system "make install"
  end

  def test
    system "gosh -V"
  end
end
