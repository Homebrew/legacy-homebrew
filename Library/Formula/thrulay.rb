require 'formula'

class Thrulay <Formula
  url 'http://shlang.com/thrulay/thrulay-0.8.tar.gz'
  homepage 'http://shlang.com/thrulay/'
  md5 '725fb13344608a652e818bcd16fe9ef6'

  def install
    inreplace "doc/Makefile.in", "@prefix@/man", "@prefix@/share/man"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make" # make install does not make
    system "make install"
  end
end
