require 'formula'

class Entr < Formula
  homepage 'http://entrproject.org/'
  url 'http://entrproject.org/code/entr-2.8.tar.gz'
  sha1 'ec03da66480cc7f8c6130e6f8599e1ae956e9b72'

  bottle do
    cellar :any
    sha1 "b1fe6118d723b9eadbec1bab469eade0943e62ed" => :mavericks
    sha1 "4768d9865e6b1c20839834ffec69e4697eaee32c" => :mountain_lion
    sha1 "f7e3bcf2fc31d896f2bb6f62711bed1de2099ed7" => :lion
  end

  def install
    ENV['PREFIX'] = prefix
    ENV['MANPREFIX'] = man
    system "./configure"
    system "make"
    system "make install"
  end
end
