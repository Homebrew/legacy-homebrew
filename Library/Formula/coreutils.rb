class Coreutils < Formula
  desc "GNU File, Shell, and Text utilities"
  homepage "https://www.gnu.org/software/coreutils"
  revision 1

  stable do
    url "http://ftpmirror.gnu.org/coreutils/coreutils-8.23.tar.xz"
    mirror "https://ftp.gnu.org/gnu/coreutils/coreutils-8.23.tar.xz"
    sha256 "ec43ca5bcfc62242accb46b7f121f6b684ee21ecd7d075059bf650ff9e37b82d"

    # Patch adapted from upstream commits:
    # http://git.savannah.gnu.org/gitweb/?p=coreutils.git;a=commitdiff;h=6f9b018
    # http://git.savannah.gnu.org/gitweb/?p=coreutils.git;a=commitdiff;h=3cf19b5
    patch :DATA
  end

  bottle do
    revision 2
    sha256 "e0db37da043274394646c8cfd50aa0aee7c57904f4517d772e4af07fd5d7712f" => :yosemite
    sha256 "2c1748f05bdcd8ea55754e31094a0b6952363dc3a0d1cca7dbc0126b0270e2ee" => :mavericks
    sha256 "22685bb77955bafd107abf0301af20b6bfa4704d8d510f8f2b57d811628361e2" => :mountain_lion
  end

  conflicts_with "ganglia", :because => "both install `gstat` binaries"
  conflicts_with "idutils", :because => "both install `gid` and `gid.1`"

  head do
    url "git://git.sv.gnu.org/coreutils"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "gettext" => :build
    depends_on "texinfo" => :build
    depends_on "xz" => :build
    depends_on "wget" => :build
  end

  def install
    system "./bootstrap" if build.head?
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

    # Symlink non-conflicting binaries
    bin.install_symlink "grealpath" => "realpath"
    man1.install_symlink "grealpath.1" => "realpath.1"
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

  def coreutils_filenames(dir)
    filenames = []
    dir.find do |path|
      next if path.directory? || path.basename.to_s == ".DS_Store"
      filenames << path.basename.to_s.sub(/^g/, "")
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
