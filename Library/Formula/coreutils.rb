require 'formula'

class Coreutils < Formula
  homepage 'http://www.gnu.org/software/coreutils'
  url 'http://ftpmirror.gnu.org/coreutils/coreutils-8.20.tar.xz'
  mirror 'http://ftp.gnu.org/gnu/coreutils/coreutils-8.20.tar.xz'
  sha256 'dbcb798764827a0f74be738662ecb516705cf520330cd3d7b2640fdffa499eb2'

  depends_on 'xz' => :build

  def patches
    # Build issue with LIBICONV. Can be removed for next release.
    # http://git.savannah.gnu.org/cgit/coreutils.git/commit/?id=88a6201917cad43fd4efea0f1c34c891b70a7414
    DATA
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--program-prefix=g"
    system "make install"

    # Symlink all commands into libexec/gnubin without the 'g' prefix
    coreutils_filenames(bin).each do |cmd|
      (libexec/'gnubin').install_symlink bin/"g#{cmd}" => cmd
    end
    # Symlink all man(1) pages into libexec/gnuman without the 'g' prefix
    coreutils_filenames(man1).each do |cmd|
      (libexec/'gnuman'/'man1').install_symlink man1/"g#{cmd}" => cmd
    end
  end

  def caveats; <<-EOS.undent
    All commands have been installed with the prefix 'g'.

    If you really need to use these commands with their normal names, you
    can add a "gnubin" directory to your PATH from your bashrc like:

        PATH="#{opt_prefix}/libexec/gnubin:$PATH"

    Additionally, you can access their man pages with normal names if you add
    the "gnuman" directory to your MANPATH from your bashrc as well:

        MANPATH="#{opt_prefix}/libexec/gnuman:$MANPATH"

    EOS
  end

  def coreutils_filenames (dir)
    filenames = []
    dir.find do |path|
      next if path.directory? or path.basename.to_s == '.DS_Store'
      filenames << path.basename.to_s.sub(/^g/,'')
    end
    filenames.sort
  end
end

__END__
diff --git a/Makefile.in b/Makefile.in
index 9768860..c8f92c2 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -3114,7 +3114,7 @@ src_expand_LDADD = $(LDADD)

 # for various GMP functions
 src_expr_LDADD = $(LDADD) $(LIB_GMP)
-src_factor_LDADD = $(LDADD) $(LIB_GMP)
+src_factor_LDADD = $(LDADD) $(LIB_GMP) $(LIBICONV)
 src_false_LDADD = $(LDADD)
 src_fmt_LDADD = $(LDADD)
 src_fold_LDADD = $(LDADD)
