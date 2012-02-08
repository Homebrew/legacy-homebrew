require 'formula'

class Tmux < Formula

  def options
    [
      ['--iterm2', 'Build with iTerm2 support.'],
    ]
  end

  url 'http://sourceforge.net/projects/tmux/files/tmux/tmux-1.6/tmux-1.6.tar.gz'
  md5 '3e37db24aa596bf108a0442a81c845b3'
  homepage 'http://tmux.sourceforge.net'
  head 'https://tmux.svn.sourceforge.net/svnroot/tmux/trunk'

  if ARGV.include? '--iterm2'
    url 'http://iterm2.googlecode.com/files/tmux-for-iTerm2-20120203.tar.gz'
    md5 '59305a26bdd0245054fe719e6b2a960e'
    homepage 'https://github.com/gnachman/tmux2'
    head 'https://github.com/gnachman/tmux2.git'
  end

  depends_on 'libevent'

  def install
    system "sh", "autogen.sh" if ARGV.build_head?

    ENV.append "LDFLAGS", '-lresolv'
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make install"

    # Install bash completion scripts for use with bash-completion
    (prefix+'etc/bash_completion.d').install "examples/bash_completion_tmux.sh" => 'tmux'
  end

  def caveats;
    s = ""
    s += <<-EOS.undent
      Bash completion script was installed to:
        #{etc}/bash_completion.d/tmux
    EOS
    return s.empty? ? nil : s
  end
end
