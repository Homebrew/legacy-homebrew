require 'formula'

class Zsh < Formula
  url 'http://downloads.sourceforge.net/project/zsh/zsh-dev/4.3.11/zsh-4.3.11.tar.gz'
  homepage 'http://www.zsh.org/'
  md5 '127e2a3b9100d6f2fddb6a32cd4aca40'

  depends_on 'gdbm' => :optional

  skip_clean :all

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          # don't version stuff in Homebrew, we already do that!
                          "--enable-fndir=#{share}/zsh/functions",
                          "--enable-scriptdir=#{share}/zsh/scripts"

    # Again, don't version installation directories
    inreplace ["Makefile", "Src/Makefile"],
      "$(libdir)/$(tzsh)/$(VERSION)", "$(libdir)"

    system "make install"
  end
end
