require 'formula'

class Atarixx < Formula
  homepage 'http://www.xl-project.com'
  url 'http://www.xl-project.com/download/atari++_1.71.tar.gz'
  sha1 '6d18494068bf491077cff32de514a1118bb133b1'

  depends_on :x11 => :optional
  depends_on 'sdl' => :recommended
  option 'with-curses'
  
  def install
    options = []
    options << "--disable-CURSES" unless build.include? 'with-curses'
    options << "--disable-SDL" unless build.include? 'with-sdl'
    options << "--disable-X11" unless build.include? 'with-x11'

    if options.length == 3
      onoe "At least choose one frontend of SDL (recommended), X11 or Curses"
      exit
    else
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", options
      system "make"
      system "make install" # if this fails, try separate make/make install steps
    end
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test atari++`.
    system "atari++"
  end
end
