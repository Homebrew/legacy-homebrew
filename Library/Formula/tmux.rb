require 'formula'

class Tmux < Formula
  homepage 'http://tmux.sourceforge.net'
  url 'http://sourceforge.net/projects/tmux/files/tmux/tmux-1.7/tmux-1.7.tar.gz'
  sha1 'ee6942a1bc3fc650036f26921d80bc4b73d56df6'

  head 'git://tmux.git.sourceforge.net/gitroot/tmux/tmux'

  depends_on 'pkg-config' => :build
  depends_on 'libevent'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  def patches
  	# https://gist.github.com/1399751
    # https://sourceforge.net/tracker/?func=detail&aid=3588949&group_id=200378&atid=973264
  	[
  		"https://raw.github.com/gist/1399751/8c5f0018c901f151d39680ef85de6d22649b687a/tmux-ambiguous-width-cjk.patch",
  	 	"https://raw.github.com/gist/1399751/752a6f29f43eb9230a61a2d34d6b36aba2327c42/tmux-do-not-combine-utf8.patch",
  	 	"https://raw.github.com/gist/1399751/6a6cf47aea405c53edc87adab0bf40531aac741d/tmux-pane-border-ascii.patch"
  	]
  end

  def install
    system "sh", "autogen.sh" if build.head?

    ENV.append "LDFLAGS", '-lresolv'
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make install"

    (prefix+'etc/bash_completion.d').install "examples/bash_completion_tmux.sh" => 'tmux'

    # Install addtional meta file
    prefix.install 'NOTES'
  end

  def caveats; <<-EOS.undent
    Additional information can be found in:
      #{prefix}/NOTES
    EOS
  end

  def test
    system "#{bin}/tmux", "-V"
  end
end

