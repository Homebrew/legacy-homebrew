require 'formula'

class Atarixx < Formula
  homepage 'http://www.xl-project.com'
  url 'http://www.xl-project.com/download/atari++_1.72.tar.gz'
  sha1 '64e31389032292cd4a82a972e83bb2b3ee723068'

  option 'with-curses'

  depends_on :x11
  depends_on 'sdl' => :recommended

  def install
    args = ["--prefix=#{prefix}"]
    args << "--disable-CURSES" unless build.include? 'with-curses'
    args << "--disable-SDL" unless build.include? 'with-sdl'

    system "./configure", *args
    system "make"
    system "make install"
  end
end
