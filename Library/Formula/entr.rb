require 'formula'

class Entr < Formula
  homepage 'http://entrproject.org/'
  url 'http://entrproject.org/code/entr-3.0.tar.gz'
  sha1 'e7c5f589b2bce839464052b116a051b4d8f43f23'

  bottle do
    cellar :any
    sha1 "088848efb975f72204ab9d5e74b7273b3a1c8bf8" => :mavericks
    sha1 "31c6173d418ff64a5feb2c4a0d00ac236cde8af7" => :mountain_lion
    sha1 "aef771a148d1417a0b5fdf2c4e1cd7b1fec89a5f" => :lion
  end

  def install
    ENV['PREFIX'] = prefix
    ENV['MANPREFIX'] = man
    system "./configure"
    system "make"
    system "make install"
  end
end
