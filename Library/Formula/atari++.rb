require 'formula'

class Atarixx < Formula
  homepage 'http://www.xl-project.com'
  url 'http://www.xl-project.com/download/atari++_1.71.tar.gz'
  sha1 '6d18494068bf491077cff32de514a1118bb133b1'

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
