require 'formula'

class TmuxForIterm2 < Formula
  url 'http://iterm2.googlecode.com/files/tmux-for-iTerm2-20120108.tar.gz'
  homepage 'http://www.iterm2.com/'
  md5 'f15d9f567b9b029482bb7b3227ee7ac3'

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
