require 'formula'

class Zsh < Formula
  homepage 'http://www.zsh.org/'
  url 'http://sourceforge.net/projects/zsh/files/zsh-dev/4.3.17/zsh-4.3.17.tar.gz'
  md5 '9074077945550d6684ebe18b3b167d52'

  depends_on 'gdbm'
  depends_on 'pcre'

  skip_clean :all

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-etcdir",
                          "--enable-fndir=#{share}/zsh/functions",
                          "--enable-site-fndir=#{share}/zsh/site-functions",
                          "--enable-scriptdir=#{share}/zsh/scripts",
                          "--enable-site-scriptdir=#{share}/zsh/site-scripts",
                          "--enable-cap",
                          "--enable-function-subdirs",
                          "--enable-maildir-support",
                          "--enable-multibyte",
                          "--enable-pcre",
                          "--enable-zsh-secure-free",
                          "--with-tcsetpgrp"

    # Do not version installation directories.
    inreplace ["Makefile", "Src/Makefile"],
      "$(libdir)/$(tzsh)/$(VERSION)", "$(libdir)"

    system "make install"
  end

  def test
    system "#{bin}/zsh --version"
  end

  def caveats; <<-EOS.undent
    To use this build of Zsh as your login shell, add it to /etc/shells.
    EOS
  end
end
