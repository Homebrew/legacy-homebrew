require 'formula'

class Cdargs < Formula
  url 'http://www.skamphausen.de/downloads/cdargs/cdargs-1.35.tar.gz'
  homepage 'http://www.skamphausen.de/cgi-bin/ska/CDargs'
  md5 '50be618d67f0b9f2439526193c69c567'

  fails_with_llvm "Bus error in ld on SL 10.6.4"

  # fixes zsh usage using the patch provided at the cdargs homepage
  # (See http://www.skamphausen.de/cgi-bin/ska/CDargs)
  def patches
    DATA
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make install-strip"

    rm Dir['contrib/Makefile*']
    prefix.install 'contrib'

    (etc+'bash_completion.d').mkpath
    ln_sf prefix+'contrib/cdargs-bash.sh', etc+'bash_completion.d/cdargs-bash.sh'
  end

  def caveats; <<-EOS.undent
      Support files for bash, tcsh and emacs are located in:
        #{prefix}/contrib

      The file for bash is also symlinked to:
        #{etc}/bash_completion.d/cdargs-bash.sh

      Source it from your .bash_profile or .bashrc to get nice aliases and bash completion.

      For zsh use the bash script.

      Consult the cdargs man page for more details and instructions.
    EOS
  end
end


__END__
diff --git a/contrib/cdargs-bash.sh b/contrib/cdargs-bash.sh
index 8a197ef..f3da067 100644
--- a/contrib/cdargs-bash.sh
+++ b/contrib/cdargs-bash.sh
@@ -11,6 +11,12 @@
 CDARGS_SORT=0   # set to 1 if you want mark to sort the list
 CDARGS_NODUPS=1 # set to 1 if you want mark to delete dups
 
+# Support ZSH via its BASH completion emulation
+if [ -n "$ZSH_VERSION" ]; then
+	autoload bashcompinit
+	bashcompinit
+fi
+
 # --------------------------------------------- #
 # Run the cdargs program to get the target      #
 # directory to be used in the various context   #
@@ -166,7 +172,7 @@ function mark ()
     local tmpfile
 
     # first clear any bookmarks with this same alias, if file exists
-    if [[ "$CDARGS_NODUPS" && -e "$HOME/.cdargs" ]]; then
+    if [ "$CDARGS_NODUPS" ] && [ -e "$HOME/.cdargs" ]; then
         tmpfile=`echo ${TEMP:-${TMPDIR:-/tmp}} | sed -e "s/\\/$//"`
         tmpfile=$tmpfile/cdargs.$USER.$$.$RANDOM
         grep -v "^$1 " "$HOME/.cdargs" > $tmpfile && 'mv' -f $tmpfile "$HOME/.cdargs";
