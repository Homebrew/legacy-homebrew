require 'formula'

class Entr < Formula
  homepage 'http://entrproject.org/'
  url 'http://entrproject.org/code/entr-2.8.tar.gz'
  sha1 'ec03da66480cc7f8c6130e6f8599e1ae956e9b72'

  def install
    ENV['PREFIX'] = prefix
    ENV['MANPREFIX'] = man
    system "./configure"
    system "make"
    system "make install"
  end
end
