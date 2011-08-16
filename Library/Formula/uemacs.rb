require 'formula'

class Uemacs < Formula
  head 'git://git.kernel.org/pub/scm/editors/uemacs/uemacs.git'
  homepage 'http://git.kernel.org/?p=editors/uemacs/uemacs.git'

  # two patches to ensure config files are loaded correctly
  def patches
    DATA
  end

  def install
    cellar_etc = prefix + 'etc'

    inreplace 'Makefile' do |s|
      s.change_make_var! 'BINDIR', bin
      s.change_make_var! 'LIBDIR', cellar_etc
      s.gsub! ".emacsrc", "emacs.rc"
    end

    inreplace 'epath.h' do |s|
      s.gsub! ".emacsrc", "emacs.rc"
      s.gsub! "/usr/local/lib", etc
    end

    bin.mkdir
    cellar_etc.mkdir

    system "make"
    system "make install"
  end

  def caveats
    <<-EOS.undent
      The system-wide configuration file, emacs.rc, has been installed to
      #{etc}. uemacs will also load ~/.emrc if it exists. You can
      override this behavior by creating the file ~/.emacsrc.
    EOS
  end
end

__END__
diff --git a/emacs.rc b/emacs.rc
index 06c0f12..e8e07b7 100644
--- a/emacs.rc
+++ b/emacs.rc
@@ -286,4 +286,7 @@ bind-to-key newline ^J
        add-global-mode "utf-8"
 !endif

+!force execute-file &cat $HOME "/.emrc"
+!force execute-file &cat ".emrc"
+
 set $discmd "TRUE"

diff --git a/bind.c b/bind.c
index eb28c1f..88911f6 100644
--- a/bind.c
+++ b/bind.c
@@ -490,7 +490,7 @@ char *flook(char *fname, int hflag)
			/* build home dir file spec */
			strcpy(fspec, home);
			strcat(fspec, "/");
-			strcat(fspec, fname);
+			strcat(fspec, ".emacsrc");

			/* and try it out */
			if (ffropen(fspec) == FIOSUC) {
