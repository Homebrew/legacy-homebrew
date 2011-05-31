require 'formula'

class Nesc < Formula
  url 'http://sourceforge.net/projects/nescc/files/nescc/v1.3.2/nesc-1.3.2.tar.gz'
  homepage 'http://nescc.sourceforge.net/'
  md5 '9daf68f3d7f4a188d4de9d50c8bc3188'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    ENV.deparallelize
    ENV.no_optimization
    system "make"  # separate make and make install steps    system "make install"
    system "make install"
  end
end
