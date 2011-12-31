require 'formula'

class Zsh < Formula
  url 'http://sourceforge.net/projects/zsh/files/zsh-dev/4.3.15/zsh-4.3.15.tar.gz'
  homepage 'http://www.zsh.org/'
  md5 'b2e2d0a431935b408ed8ea48226f9962'

  depends_on 'gdbm' => :optional

  skip_clean :all

  def install
    system "./configure", "--prefix=#{prefix}",
                          # don't version stuff in Homebrew, we already do that!
                          "--enable-fndir=#{share}/zsh/functions",
                          "--enable-scriptdir=#{share}/zsh/scripts"

    # Again, don't version installation directories
    inreplace ["Makefile", "Src/Makefile"],
      "$(libdir)/$(tzsh)/$(VERSION)", "$(libdir)"

    system "make install"
  end

  def caveats; <<-EOS.undent
    In order to use this build of zsh as your login shell,
    it must be added to /etc/shells.
    EOS
  end
end
