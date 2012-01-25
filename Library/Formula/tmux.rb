require 'formula'

class Tmux < Formula
  url 'http://sourceforge.net/projects/tmux/files/tmux/tmux-1.6/tmux-1.6.tar.gz'
  md5 '3e37db24aa596bf108a0442a81c845b3'
  homepage 'http://tmux.sourceforge.net'

  depends_on 'libevent'

  def install
    ENV.append "LDFLAGS", '-lresolv'
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--sysconfdir=#{etc}"
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
