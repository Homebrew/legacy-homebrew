class Zsh < Formula
  desc "UNIX shell (command interpreter)"
  homepage "http://www.zsh.org/"
  url "https://downloads.sourceforge.net/project/zsh/zsh/5.1/zsh-5.1.tar.gz"
  mirror "http://www.zsh.org/pub/zsh-5.1.tar.gz"
  sha256 "e3731381810e690fb955cedfa8be51b0934bfa1ff38c709f54138960e3decd99"

  bottle do
    revision 1
    sha256 "0b25363741f6511290d28d56f620ccfda25c1e7938d255f35336bef1c0355e94" => :yosemite
    sha256 "afb1a3bc447b2ba5a8b2a4f30d33750a5195cb08412213a9dc48dc9b7bb4308a" => :mavericks
    sha256 "c68dff49299b118989c53654f668733afe191cdb2bcd965eca849f331ddc68d6" => :mountain_lion
  end

  option "without-etcdir", "Disable the reading of Zsh rc files in /etc"

  deprecated_option "disable-etcdir" => "without-etcdir"

  depends_on "gdbm"
  depends_on "pcre"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-fndir=#{share}/zsh/functions
      --enable-scriptdir=#{share}/zsh/scripts
      --enable-site-fndir=#{HOMEBREW_PREFIX}/share/zsh/site-functions
      --enable-site-scriptdir=#{HOMEBREW_PREFIX}/share/zsh/site-scripts
      --enable-runhelpdir=#{share}/zsh/help
      --enable-cap
      --enable-maildir-support
      --enable-multibyte
      --enable-pcre
      --enable-zsh-secure-free
      --with-tcsetpgrp
    ]

    if build.without? "etcdir"
      args << "--disable-etcdir"
    else
      args << "--enable-etcdir=/etc"
    end

    system "./configure", *args

    # Do not version installation directories.
    inreplace ["Makefile", "Src/Makefile"],
      "$(libdir)/$(tzsh)/$(VERSION)", "$(libdir)"

    system "make", "install"
    system "make", "install.info"
  end

  def caveats; <<-EOS.undent
    Add the following to your zshrc to access the online help:
      unalias run-help
      autoload run-help
      HELPDIR=#{HOMEBREW_PREFIX}/share/zsh/help
    EOS
  end

  test do
    assert_equal "homebrew\n",
      shell_output("#{bin}/zsh -c 'echo homebrew'")
  end
end
