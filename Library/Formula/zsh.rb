require 'formula'

class Zsh < Formula
  url 'http://downloads.sourceforge.net/project/zsh/zsh-dev/4.3.12/zsh-4.3.12.tar.gz'
  head 'git://zsh.git.sf.net/gitroot/zsh/zsh', :using => :git
  homepage 'http://www.zsh.org/'
  sha1 '72c7a52905f821433d85fbc93345d3115b15681d'
  version "4.3.12"

  depends_on 'gdbm' => :optional
  depends_on 'yodl' if ARGV.build_head?

  skip_clean :all

  def install
    if ARGV.build_head?
      system "./Util/preconfig"
    end

    system "./configure", "--prefix=#{prefix}",
                          # don't version stuff in Homebrew, we already do that!
                          "--enable-fndir=#{share}/zsh/functions",
                          "--enable-scriptdir=#{share}/zsh/scripts"

    # Again, don't version installation directories
    inreplace ["Makefile", "Src/Makefile"],
      "$(libdir)/$(tzsh)/$(VERSION)", "$(libdir)"

    if ARGV.build_head?
      system "make"
    end

    system "make install"
  end

  def caveats; <<-EOS.undent
    In order to use this build of zsh as your login shell,
    it must be added to /etc/shells.
    EOS
  end
end
