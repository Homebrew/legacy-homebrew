require 'formula'

class Clpbar < Formula
  homepage 'http://clpbar.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/clpbar/clpbar/bar-1.11.1/bar_1.11.1.tar.gz'
  sha1 '112d54cec7ebe85aacc6c2ef7d55e297264d1dd5'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--program-prefix='clp'"
    system "make install"
  end
end
