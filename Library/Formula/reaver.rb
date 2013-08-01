require 'formula'

class Reaver < Formula
  homepage 'http://code.google.com/p/reaver-wps/'

  url 'http://reaver-wps.googlecode.com/files/reaver-1.4.tar.gz'
  sha1 '2ebec75c3979daa7b576bc54adedc60eb0e27a21'

  def install
    cd "src"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    bin.mkpath
    system "make install"
    system "gunzip ../docs/reaver.1.gz"
    man1.install ['../docs/reaver.1']
  end

  def test
    system "#{bin}/reaver --help 2>&1 | grep Reaver"
  end

  def patches
    # Adds general support for Mac OS X in reaver: http://code.google.com/p/reaver-wps/issues/detail?id=245
    "https://gist.github.com/syndicut/6134996/raw/reaver-osx.diff"
  end
end
