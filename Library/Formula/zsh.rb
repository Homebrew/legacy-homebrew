require 'formula'

class Zsh < Formula
  homepage 'http://www.zsh.org/'
  url 'https://downloads.sourceforge.net/project/zsh/zsh/5.0.5/zsh-5.0.5.tar.bz2'
  mirror 'http://www.zsh.org/pub/zsh-5.0.5.tar.bz2'
  sha1 '75426146bce45ee176d9d50b32f1ced78418ae16'

  bottle do
    sha1 "d8d7ba4016377561d5d823a30abff7c81fee1577" => :mavericks
    sha1 "34fbefd6275edb7ee9fcc8d0ce3da4438ca412b1" => :mountain_lion
    sha1 "63a53240287c1f11204217176aab8246eab4d43c" => :lion
  end

  depends_on 'gdbm'
  depends_on 'pcre'

  option 'disable-etcdir', 'Disable the reading of Zsh rc files in /etc'

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-fndir=#{share}/zsh/functions
      --enable-scriptdir=#{share}/zsh/scripts
      --enable-site-fndir=#{HOMEBREW_PREFIX}/share/zsh/site-functions
      --enable-site-scriptdir=#{HOMEBREW_PREFIX}/share/zsh/site-scripts
      --enable-cap
      --enable-maildir-support
      --enable-multibyte
      --enable-pcre
      --enable-zsh-secure-free
      --with-tcsetpgrp
    ]

    if build.include? 'disable-etcdir'
      args << '--disable-etcdir'
    else
      args << '--enable-etcdir=/etc'
    end

    system "./configure", *args

    # Do not version installation directories.
    inreplace ["Makefile", "Src/Makefile"],
      "$(libdir)/$(tzsh)/$(VERSION)", "$(libdir)"

    system "make", "install"
    system "make", "install.info"
  end

  test do
    system "#{bin}/zsh", "--version"
  end

  def caveats; <<-EOS.undent
    Add the following to your zshrc to access the online help:
      unalias run-help
      autoload run-help
      HELPDIR=#{HOMEBREW_PREFIX}/share/zsh/helpfiles
    EOS
  end
end
