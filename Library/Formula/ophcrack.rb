require 'formula'
class Ophcrack < Formula
  homepage 'http://ophcrack.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/ophcrack/ophcrack/3.4.0/ophcrack-3.4.0.tar.bz2'
  sha1 '346f7e4689f2c0fc65ba7087b1ae91d00edf15b6'

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-gui
      --disable-debug
    ]

    system "./configure", *args
    system "make"
    system "cd src; make install"
  end
end
