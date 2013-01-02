require 'formula'

class Faad2 < Formula
  url 'http://downloads.sourceforge.net/project/faac/faad2-src/faad2-2.7/faad2-2.7.tar.bz2'
  sha1 'b0e80481d27ae9faf9e46c8c8dfb617a0adb91b5'
  homepage 'http://www.audiocoding.com/faad2.html'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
    man1.install man+'manm/faad.man' => 'faad.1'
  end
end
