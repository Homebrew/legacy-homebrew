require 'formula'

class Tmux <Formula
  url 'http://downloads.sourceforge.net/tmux/tmux-1.3.tar.gz'
  md5 '96e60cb206de2db0610b9fb6a64c2251'
  homepage 'http://tmux.sourceforge.net'

  depends_on 'libevent'

  def install
    ENV['PREFIX'] = prefix
    system "./configure"

    inreplace "GNUmakefile" do |f|
      # Fix 'install' flags
      f.gsub! " -g bin -o root", ""
      # Put docs in the right place
      f.gsub! "man/man1", "share/man/man1"
    end

    system "make install"
  end
end
