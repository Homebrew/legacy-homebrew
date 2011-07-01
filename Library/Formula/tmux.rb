require 'formula'

class Tmux < Formula
  url 'http://sourceforge.net/projects/tmux/files/tmux/tmux-1.4/tmux-1.4.tar.gz'
  md5 '0bfc7dd9a5bab192406167589c716a21'
  homepage 'http://tmux.sourceforge.net'

  depends_on 'libevent'

  def install
    ENV['PREFIX'] = prefix
    system "./configure"

    # Put man pages in the right place
    inreplace "GNUmakefile", "man/man1", "share/man/man1"

    system "make install"
    # Install bash completion scripts for use with bash-completion
    (prefix+'etc/bash_completion.d').install "examples/bash_completion_tmux.sh" => 'tmux'
  end

  def caveats; <<-EOS.undent
    Bash completion script was installed to:
      #{etc}/bash_completion.d/tmux
    EOS
  end
end
