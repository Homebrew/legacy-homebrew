require 'brewkit'

class Scummvm <Formula
  @url='http://downloads.sourceforge.net/project/scummvm/scummvm/0.13.1/scummvm-0.13.1.tar.bz2'
  @homepage='http://www.scummvm.org/'
  @md5='843d9cd4470022bd3b269eb84298dc16'

  def caveats
    <<-EOS
ScummVM provide their own Mac build and as such that is the one they
officially support on this platform. Ours is more optimised, but you may
prefer to use theirs. If so type `brew home scummvm' to visit their site.
    EOS
  end

  def deps
    { :required => 'sdl', :recommended => %w[flac libogg libvorbis] }
  end

  def install
    system "./configure --prefix='#{prefix}' --disable-debug"
    system "make install"
    share=prefix+'share'
    (share+'scummvm'+'scummmodern.zip').unlink
    (share+'pixmaps').rmtree
  end
end
