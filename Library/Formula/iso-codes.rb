require 'formula'

class IsoCodes < Formula
  homepage 'http://pkg-isocodes.alioth.debian.org/'
  url 'http://pkg-isocodes.alioth.debian.org/downloads/iso-codes-3.45.tar.xz'
  sha1 '15d7289efb3e4e115559a71f12681c5e396ffc52'

  depends_on 'xz' => :build
  depends_on 'gettext' => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
