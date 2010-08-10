require 'formula'

class Scummvm <Formula
  url 'http://downloads.sourceforge.net/project/scummvm/scummvm/1.0.0/scummvm-1.0.0.tar.bz2'
  homepage 'http://www.scummvm.org/'
  md5 '11b911937e0fc73c94a7bdc374ab617c'

  def caveats
    <<-EOS
ScummVM provide their own Mac build and as such that is the one they
officially support on this platform. Ours is more optimised, but you may
prefer to use theirs. If so type `brew home scummvm' to visit their site.
    EOS
  end

  depends_on 'sdl'
  depends_on 'flac' => :recommended
  depends_on 'libvorbis' => :recommended
  depends_on 'libogg' => :recommended

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug"
    system "make install"
    (share+'pixmaps').rmtree
  end
end
