require 'formula'

class Tmux <Formula
  url 'http://downloads.sourceforge.net/tmux/tmux-1.1.tar.gz'
  homepage 'http://tmux.sourceforge.net'
  md5 'faf2fc52ac3ae63d899f6fece2c112cd'

  def install
    ENV['PREFIX'] = "#{prefix}"
    system "./configure"
    inreplace "GNUmakefile", " -g bin -o root", ""
    inreplace "GNUmakefile", "man/man1", "share/man/man1"
    system "make install"
  end
end
