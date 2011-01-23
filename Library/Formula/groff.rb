require 'formula'

class Groff <Formula
  url 'http://groff.ffii.org/groff/groff-1.20.1.tar.gz'
  md5 '48fa768dd6fdeb7968041dd5ae8e2b02'
  homepage 'http://www.gnu.org/software/groff/'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--without-x"
    system "make"
    system "make install"
  end
end
