require 'formula'

class Tmux < Formula
  homepage 'http://tmux.sourceforge.net'
  url 'http://sourceforge.net/projects/tmux/files/tmux/tmux-1.6/tmux-1.6.tar.gz'
  sha1 '8756f6bcecb18102b87e5d6f5952ba2541f68ed3'

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

    # Install addtional meta file
    prefix.install 'NOTES'
  end

  def caveats; <<-EOS.undent
    Additional information can be found in:
      #{prefix}/NOTES

    Bash completion script was installed to:
      #{etc}/bash_completion.d/tmux
    EOS
  end

  def test
    system "#{bin}/tmux", "-V"
  end
end
