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
    args << "--disable-CURSES" if build.without? "curses"
    args << "--disable-SDL" if build.without? "sdl"

    system "./configure", *args
    system "make"
    system "make install"
  end
end
