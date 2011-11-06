require 'formula'

class Dcfldd < Formula
  url 'http://downloads.sourceforge.net/project/dcfldd/dcfldd/1.3.4-1/dcfldd-1.3.4-1.tar.gz'
  homepage 'http://dcfldd.sourceforge.net/'
  md5 '952026c872f11b53ce0ec6681a3eef0a'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
