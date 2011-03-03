require 'formula'

class Tmux <Formula
  url 'http://downloads.sourceforge.net/tmux/tmux-1.4.tar.gz'
  md5 '0bfc7dd9a5bab192406167589c716a21'
  homepage 'http://tmux.sourceforge.net'

  depends_on 'libevent'

  def install
    ENV['PREFIX'] = prefix
    system "./configure"

    inreplace "GNUmakefile" do |s|
      # Fix 'install' flags
      s.gsub! " -g bin -o root", ""
      # Put docs in the right place
      s.gsub! "man/man1", "share/man/man1"
    end

    system "make install"
  end
end
