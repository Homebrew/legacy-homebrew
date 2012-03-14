require 'formula'

class TmuxForIterm2 < Formula
  url 'http://iterm2.googlecode.com/files/tmux-for-iTerm2-20120203.tar.gz'
  homepage 'http://www.iterm2.com/'
  md5 '59305a26bdd0245054fe719e6b2a960e'

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
