class Coreutils < Formula
  homepage "https://www.gnu.org/software/coreutils"
  url "http://ftpmirror.gnu.org/coreutils/coreutils-8.23.tar.xz"
  mirror "https://ftp.gnu.org/gnu/coreutils/coreutils-8.23.tar.xz"
  sha256 "ec43ca5bcfc62242accb46b7f121f6b684ee21ecd7d075059bf650ff9e37b82d"
  revision 1

  bottle do
    revision 1
    sha1 "380f3f5fbd0da33e69d19edba4ae30b7e7cf899c" => :yosemite
    sha1 "edf8d1fc1ac7104b570bd72003e10ca3599302f5" => :mavericks
    sha1 "fe7525c7ef751f07f1f7dd7b37d4f584d2891210" => :mountain_lion
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
    system "make", "install"

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

  test do
    (testpath/"test").write("test")
    (testpath/"test.sha1").write("a94a8fe5ccb19ba61c4c0873d391e987982fbbd3 test")
    system "#{bin}/gsha1sum", "-c", "test.sha1"
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
