require 'brewkit'

class Tmux <Formula
  url 'http://downloads.sourceforge.net/tmux/tmux-1.0.tar.gz'
  homepage 'http://tmux.sourceforge.net'
  md5 '716b12d9ea052f57d917bf2869d419df'

  def install
    ENV['PREFIX'] = "#{prefix}"
    system "./configure"
    inreplace "GNUmakefile", " -g bin -o root", ""
    inreplace "GNUmakefile", "man/man1", "share/man/man1"
    system "make install"
  end
end
