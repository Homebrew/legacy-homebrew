require 'formula'

class Vim < Formula
  homepage 'http://www.vim.org/'
  head 'https://vim.googlecode.com/hg/'
  # This package tracks debian-unstable: http://packages.debian.org/unstable/vim
  url 'http://ftp.debian.org/debian/pool/main/v/vim/vim_7.4.161.orig.tar.gz'
  sha1 '111e9a237fa240895db013c1e546dd02580a2940'

  # We only have special support for finding depends_on :python, but not yet for
  # :ruby, :perl etc., so we use the standard environment that leaves the
  # PATH as the user has set it right now.
  env :std

  option "override-system-vi", "Override system vi"
  option "disable-nls", "Build vim without National Language Support (translated messages, keymaps)"
  option "with-client-server", "Enable client/server mode"

  LANGUAGES_OPTIONAL = %w(lua mzscheme perl python3 tcl)
  LANGUAGES_DEFAULT  = %w(ruby python)

  LANGUAGES_OPTIONAL.each do |language|
    option "with-#{language}", "Build vim with #{language} support"
  end
  LANGUAGES_DEFAULT.each do |language|
    option "without-#{language}", "Build vim without #{language} support"
  end

  depends_on :python => :recommended
  depends_on 'python3' => :optional
  depends_on 'lua' => :optional
  depends_on 'gtk+' if build.with? 'client-server'

  conflicts_with 'ex-vi',
    :because => 'vim and ex-vi both install bin/ex and bin/view'

  # First patch: patch for adding option to disable insert completion message
  # This allows plugins like You-Complete-Me and alike to silence very annoying
  # messages about user defined completion patterns
  # https://github.com/Valloric/YouCompleteMe/issues/642
  # Reported upstream: https://groups.google.com/forum/#!topic/vim_dev/WeBBjkXE8H8
  def patches; DATA; end unless build.head?

  def install
    ENV['LUA_PREFIX'] = HOMEBREW_PREFIX if build.with?('lua')

    # vim doesn't require any Python package, unset PYTHONPATH.
    ENV.delete('PYTHONPATH')

    opts = []
    opts += LANGUAGES_OPTIONAL.map do |language|
      "--enable-#{language}interp" if build.with? language
    end
    opts += LANGUAGES_DEFAULT.map do |language|
      "--enable-#{language}interp" if build.with? language
    end
    if opts.include? "--enable-pythoninterp" and opts.include? "--enable-python3interp"
      opts = opts - %W[--enable-pythoninterp --enable-python3interp] + %W[--enable-pythoninterp=dynamic --enable-python3interp=dynamic]
    end

    opts << "--disable-nls" if build.include? "disable-nls"

    if build.with? 'client-server'
      opts << '--enable-gui=gtk2'
    else
      opts << "--enable-gui=no"
      opts << "--without-x"
    end

    # XXX: Please do not submit a pull request that hardcodes the path
    # to ruby: vim can be compiled against 1.8.x or 1.9.3-p385 and up.
    # If you have problems with vim because of ruby, ensure a compatible
    # version is first in your PATH when building vim.

    # We specify HOMEBREW_PREFIX as the prefix to make vim look in the
    # the right place (HOMEBREW_PREFIX/share/vim/{vimrc,vimfiles}) for
    # system vimscript files. We specify the normal installation prefix
    # when calling "make install".
    system "./configure", "--prefix=#{HOMEBREW_PREFIX}",
                          "--mandir=#{man}",
                          "--enable-multibyte",
                          "--with-tlib=ncurses",
                          "--enable-cscope",
                          "--with-features=huge",
                          "--with-compiledby=Homebrew",
                          *opts

    system "make"
    # If stripping the binaries is not enabled, vim will segfault with
    # statically-linked interpreters like ruby
    # http://code.google.com/p/vim/issues/detail?id=114&thanks=114&ts=1361483471
    system "make", "install", "prefix=#{prefix}", "STRIP=/usr/bin/true"
    bin.install_symlink "vim" => "vi" if build.include? "override-system-vi"
  end

  def caveats
    s = ''
    if build.with? "python" and build.with? "python3"
      s += <<-EOS.undent
        Vim has been built with dynamic loading of Python 2 and Python 3.

        Note: if Vim dynamically loads both Python 2 and Python 3, it may
        crash. For more information, see:
            http://vimdoc.sourceforge.net/htmldoc/if_pyth.html#python3
      EOS
    end
  end
end

__END__
diff -r 462a4499f9c6 runtime/doc/options.txt
--- a/runtime/doc/options.txt	Fri Nov 29 14:24:42 2013 +0900
+++ b/runtime/doc/options.txt	Fri Nov 29 18:07:09 2013 +0900
@@ -6259,6 +6259,9 @@
 	  A	don't give the "ATTENTION" message when an existing swap file
 		is found.
 	  I	don't give the intro message when starting Vim |:intro|.
+	  c	don't give the |ins-completion-menu| message.  For example,
+		"-- XXX completion (YYY)", "match 1 of 2", "The only match",
+		"Pattern not found", "Back at original", etc.
 
 	This gives you the opportunity to avoid that a change between buffers
 	requires you to hit <Enter>, but still gives as useful a message as
diff -r 462a4499f9c6 src/edit.c
--- a/src/edit.c	Fri Nov 29 14:24:42 2013 +0900
+++ b/src/edit.c	Fri Nov 29 18:07:09 2013 +0900
@@ -3878,7 +3878,8 @@
 	    ins_compl_free();
 	    compl_started = FALSE;
 	    compl_matches = 0;
-	    msg_clr_cmdline();		/* necessary for "noshowmode" */
+	    if (!shortmess(SHM_COMPLETIONMENU))
+		msg_clr_cmdline();	/* necessary for "noshowmode" */
 	    ctrl_x_mode = 0;
 	    compl_enter_selects = FALSE;
 	    if (edit_submode != NULL)
@@ -5333,7 +5334,8 @@
 	    {
 		ctrl_x_mode = 0;
 		edit_submode = NULL;
-		msg_clr_cmdline();
+		if (!shortmess(SHM_COMPLETIONMENU))
+		    msg_clr_cmdline();
 		return FAIL;
 	    }
 
@@ -5594,12 +5596,12 @@
     showmode();
     if (edit_submode_extra != NULL)
     {
-	if (!p_smd)
+	if (!p_smd && !shortmess(SHM_COMPLETIONMENU))
 	    msg_attr(edit_submode_extra,
 		    edit_submode_highl < HLF_COUNT
 		    ? hl_attr(edit_submode_highl) : 0);
     }
-    else
+    else if (!shortmess(SHM_COMPLETIONMENU))
 	msg_clr_cmdline();	/* necessary for "noshowmode" */
 
     /* Show the popup menu, unless we got interrupted. */
diff -r 462a4499f9c6 src/option.h
--- a/src/option.h	Fri Nov 29 14:24:42 2013 +0900
+++ b/src/option.h	Fri Nov 29 18:07:09 2013 +0900
@@ -212,7 +212,8 @@
 #define SHM_SEARCH	's'		/* no search hit bottom messages */
 #define SHM_ATTENTION	'A'		/* no ATTENTION messages */
 #define SHM_INTRO	'I'		/* intro messages */
-#define SHM_ALL		"rmfixlnwaWtToOsAI" /* all possible flags for 'shm' */
+#define SHM_COMPLETIONMENU	'c'	/* completion menu messages */
+#define SHM_ALL		"rmfixlnwaWtToOsAIc" /* all possible flags for 'shm' */
 
 /* characters for p_go: */
 #define GO_ASEL		'a'		/* autoselect */
diff -r 462a4499f9c6 src/screen.c
--- a/src/screen.c	Fri Nov 29 14:24:42 2013 +0900
+++ b/src/screen.c	Fri Nov 29 18:07:09 2013 +0900
@@ -9704,7 +9704,8 @@
 	    }
 #endif
 #ifdef FEAT_INS_EXPAND
-	    if (edit_submode != NULL)		/* CTRL-X in Insert mode */
+	    /* CTRL-X in Insert mode */
+	    if (edit_submode != NULL && !shortmess(SHM_COMPLETIONMENU))
 	    {
 		/* These messages can get long, avoid a wrap in a narrow
 		 * window.  Prefer showing edit_submode_extra. */
=======
>>>>>>> master
