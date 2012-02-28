require 'formula'

def autotools_exist?
  `which aclocal` != '' and `which autoreconf` != '' and `which libtool` != ''
end

class SdlSound < Formula
  url 'http://icculus.org/SDL_sound/downloads/SDL_sound-1.0.3.tar.gz'
  homepage 'http://icculus.org/SDL_sound/'
  md5 'aa09cd52df85d29bee87a664424c94b5'
  head 'http://hg.icculus.org/icculus/SDL_sound', :using => :hg

  depends_on 'pkg-config' => :build
  depends_on 'sdl'
  depends_on 'flac' => :optional
  depends_on 'libmikmod' if autotools_exist?
  depends_on 'libogg' => :optional
  depends_on 'libvorbis' => :optional
  depends_on 'speex' => :optional
  depends_on 'physfs' => :optional

  def install
    # Bail out if the tools to build head don't exist. Those tools
    # can come from either the system or Homebrew.
    if ARGV.build_head? and not autotools_exist?
      onoe <<-EOS.undent
        Can't build head without autoreconf and aclocal.  Those tools
               are not part of XCode-4.3 or the Command Line Tools.
                 * autoconf: is a part of adamv/homebrew-alt on github
                 * aclocal:  is a part of automake. Check homebrew-alt\n
      EOS
      Process.exit
    end

    system "./bootstrap" if ARGV.build_head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-sdltest"
    system "make"
    system "make check"
    system "make install"
  end
end
