require 'formula'

class Tmux < Formula
  url 'http://sourceforge.net/projects/tmux/files/tmux/tmux-1.6/tmux-1.6.tar.gz'
  md5 '3e37db24aa596bf108a0442a81c845b3'
  homepage 'http://tmux.sourceforge.net'

  head 'https://tmux.svn.sourceforge.net/svnroot/tmux/trunk'

  depends_on 'libevent'

  if ARGV.build_head? and MacOS.xcode_version >= "4.3"
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "sh", "autogen.sh" if ARGV.build_head?

    ENV.append "LDFLAGS", '-lresolv'
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make install"

    # Install bash completion scripts for use with bash-completion
    (prefix+'etc/bash_completion.d').install "examples/bash_completion_tmux.sh" => 'tmux'

    # Install vim syntax file as a plugin.
    (Pathname.pwd+'examples/ftdetect-tmux.vim').open('w') do |f|
      f.print <<-EOS.undent
        " Created by HomeBrew
        au BufNewFile,BufRead .tmux.conf*,tmux.conf* set filetype=tmux
      EOS
    end
    (share+'vim/vimfiles/ftdetect').install "examples/ftdetect-tmux.vim" => "tmux.vim"
    (share+'vim/vimfiles/syntax').install "examples/tmux.vim"

  end

  def caveats; <<-EOS.undent
    Bash completion script was installed to:
      #{etc}/bash_completion.d/tmux

    If you use Apple's vim and want syntax highlighting for
    your .tmux.conf then add this to your .vimrc:
        set runtimepath+=/usr/local/share/vim/vimfiles/

    Syntax highlighting should work automatically with the vim from homedir-dupes.
    EOS
  end

  def test
    system "#{bin}/tmux -V"
  end
end
