require "formula"

class Coreutils < Formula
  homepage "https://www.gnu.org/software/coreutils"
  url "http://ftpmirror.gnu.org/coreutils/coreutils-8.23.tar.xz"
  mirror "https://ftp.gnu.org/gnu/coreutils/coreutils-8.23.tar.xz"
  sha256 "ec43ca5bcfc62242accb46b7f121f6b684ee21ecd7d075059bf650ff9e37b82d"
  revision 1

  bottle do
    sha1 "2e0bcc5019f66bfbe1d037883c21d8df807d3155" => :mavericks
    sha1 "5241674b7ccd1aa0849f2bc4461137020473769f" => :mountain_lion
    sha1 "599c8ceab94b433ee909b62aa6e20249c660f424" => :lion
  end

  conflicts_with "ganglia", :because => "both install `gstat` binaries"
  conflicts_with "idutils", :because => "both install `gid` and `gid.1`"

  # Patch adapted from upstream commits:
  # http://git.savannah.gnu.org/gitweb/?p=coreutils.git;a=commitdiff;h=6f9b018
  # http://git.savannah.gnu.org/gitweb/?p=coreutils.git;a=commitdiff;h=3cf19b5
  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--program-prefix=g",
                          "--without-gmp"
    system "make install"

    # Symlink all commands into libexec/gnubin without the 'g' prefix
    coreutils_filenames(bin).each do |cmd|
      (libexec/"gnubin").install_symlink bin/"g#{cmd}" => cmd
    end
    # Symlink all man(1) pages into libexec/gnuman without the 'g' prefix
    coreutils_filenames(man1).each do |cmd|
      (libexec/"gnuman"/"man1").install_symlink man1/"g#{cmd}" => cmd
    end
  end

  def caveats; <<-EOS.undent
    All commands have been installed with the prefix 'g'.

    If you really need to use these commands with their normal names, you
    can add a "gnubin" directory to your PATH from your bashrc like:

        PATH="#{opt_libexec}/gnubin:$PATH"

    Additionally, you can access their man pages with normal names if you add
    the "gnuman" directory to your MANPATH from your bashrc as well:

        MANPATH="#{opt_libexec}/gnuman:$MANPATH"

    EOS
  end

  def coreutils_filenames (dir)
    filenames = []
    dir.find do |path|
      next if path.directory? or path.basename.to_s == ".DS_Store"
      filenames << path.basename.to_s.sub(/^g/,"")
    end
    filenames.sort
  end
end

__END__
diff --git a/Makefile.in b/Makefile.in
index 140a428..bae3163 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -2566,7 +2566,7 @@ pkglibexecdir = @pkglibexecdir@
 # Use 'ginstall' in the definition of PROGRAMS and in dependencies to avoid
 # confusion with the 'install' target.  The install rule transforms 'ginstall'
 # to install before applying any user-specified name transformations.
-transform = s/ginstall/install/; $(program_transform_name)
+transform = s/ginstall/install/;/libstdbuf/!$(program_transform_name)
 ACLOCAL = @ACLOCAL@
 ALLOCA = @ALLOCA@
 ALLOCA_H = @ALLOCA_H@
