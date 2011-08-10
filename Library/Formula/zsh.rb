require 'formula'

class Zsh < Formula
  url 'http://downloads.sourceforge.net/project/zsh/zsh-dev/4.3.12/zsh-4.3.12.tar.gz'
  homepage 'http://www.zsh.org/'
  md5 '46ae7be975779b9b0ea24e8b30479a8b'

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
end
