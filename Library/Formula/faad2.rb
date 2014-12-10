require 'formula'

class Faad2 < Formula
  homepage 'http://www.audiocoding.com/faad2.html'
  url 'https://downloads.sourceforge.net/project/faac/faad2-src/faad2-2.7/faad2-2.7.tar.bz2'
  sha1 'b0e80481d27ae9faf9e46c8c8dfb617a0adb91b5'

  bottle do
    cellar :any
    revision 1
    sha1 "39cc3707e90db859db8cb135ccd7080f9c304459" => :yosemite
    sha1 "04c2c277cfd485ccf2741e0655d80f5e15cf8cd3" => :mavericks
    sha1 "08c8bc69ca372e20e233da8deabd5367ea0f345d" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
    man1.install man+'manm/faad.man' => 'faad.1'
  end
end
