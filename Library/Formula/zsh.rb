require 'formula'

class Zsh < Formula
  desc "A UNIX shell (command interpreter)"
  homepage 'http://www.zsh.org/'
  url 'https://downloads.sourceforge.net/project/zsh/zsh/5.0.8/zsh-5.0.8.tar.bz2'
  mirror 'http://www.zsh.org/pub/zsh-5.0.8.tar.bz2'
  sha256 '8079cf08cb8beff22f84b56bd72bb6e6962ff4718d816f3d83a633b4c9e17d23'

  bottle do
    sha256 "86da8afbbaa7a5a84b6362638f101a0698ac669a55282991c3488de4c1f6d6f3" => :yosemite
    sha256 "748fd3b2f72b74bc63639aaa0b9bff59cd25592b94b4b84b4574cde7d0399fe8" => :mavericks
    sha256 "808e64fa41634261b1427eff37ba4b1f1708d642504461c63cc3d10c073c735a" => :mountain_lion
  end

  depends_on 'gdbm'
  depends_on 'pcre'

  option 'disable-etcdir', 'Disable the reading of Zsh rc files in /etc'

  # zsh 5.0.8 broke du tab-completion for files, but this has been fixed in
  # bug #35467. We ship our own version of the patch to avoid CHANGELOG
  # conflicts.
  # https://github.com/zsh-users/zsh/commit/806f73a0b3d3959d5af12ce97e0258b4d4fe7d76.patch
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
      HELPDIR=#{HOMEBREW_PREFIX}/share/zsh/help
    EOS
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
