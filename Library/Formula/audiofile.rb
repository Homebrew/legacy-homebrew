require 'formula'

class Audiofile < Formula
  url 'http://ftp.gnome.org/pub/gnome/sources/audiofile/0.2/audiofile-0.2.7.tar.gz'
  homepage 'http://www.68k.org/~michael/audiofile/'
  md5 'a39be317a7b1971b408805dc5e371862'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
