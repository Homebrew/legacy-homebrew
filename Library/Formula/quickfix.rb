require 'formula'

class Quickfix < Formula
  url 'http://downloads.sourceforge.net/project/quickfix/quickfix/1.13.3/quickfix-1.13.3.tar.gz'
  homepage 'http://www.quickfixengine.org/index.html'
  md5 '1e569a32107ecfc1de9c15bdcb5dc360'

  def install
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]

    # same as in MacPorts quickfix
    args << "--with-java"

    # there could be options for Python etc. Please fork/add if you need it:
    # - http://www.quickfixengine.org/quickfix/doc/html/building.html
    # - https://trac.macports.org/browser/trunk/dports/devel/quickfix/Portfile

    system "./configure", *args
    system "make"
    ENV.j1 # failed otherwise
    system "make install"
  end
end
