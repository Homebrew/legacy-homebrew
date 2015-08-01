class Zsh < Formula
  desc "UNIX shell (command interpreter)"
  homepage "http://www.zsh.org/"
  url "https://downloads.sourceforge.net/project/zsh/zsh/5.0.8/zsh-5.0.8.tar.bz2"
  mirror "http://www.zsh.org/pub/zsh-5.0.8.tar.bz2"
  sha256 "8079cf08cb8beff22f84b56bd72bb6e6962ff4718d816f3d83a633b4c9e17d23"

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

  # zsh 5.0.8 broke du tab-completion for files, but this has been fixed in
  # bug #35467. We ship our own version of the patch to avoid CHANGELOG conflict.
  # http://sourceforge.net/p/zsh/code/ci/806f73a0b3d3959d5af12ce97e0258b4d4fe7d76/
  patch :DATA

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
    system "#{bin}/zsh", "--version"
  end
end

__END__
diff --git a/Completion/Unix/Command/_du b/Completion/Unix/Command/_du
index d8871cd..4065a20 100644
--- a/Completion/Unix/Command/_du
+++ b/Completion/Unix/Command/_du
@@ -74,5 +74,5 @@ else
   do
     [[ $OSTYPE = $~pattern ]] && args+=( $arg )
   done
-  _arguments -s -A "-*" $args
+  _arguments -s -A "-*" $args '*:file:_files'
 fi
