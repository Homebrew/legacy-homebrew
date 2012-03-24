require 'formula'

class Quickfix < Formula
  homepage 'http://www.quickfixengine.org/index.html'
  url 'http://downloads.sourceforge.net/project/quickfix/quickfix/1.13.3/quickfix-1.13.3.tar.gz'
  md5 '1e569a32107ecfc1de9c15bdcb5dc360'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-java"
    system "make"
    ENV.j1 # failed otherwise
    system "make install"
  end
end
