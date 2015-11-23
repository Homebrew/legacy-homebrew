class Coreutils < Formula
  desc "GNU File, Shell, and Text utilities"
  homepage "https://www.gnu.org/software/coreutils"
  url "http://ftpmirror.gnu.org/coreutils/coreutils-8.24.tar.xz"
  mirror "https://ftp.gnu.org/gnu/coreutils/coreutils-8.24.tar.xz"
  sha256 "a2d75286a4b9ef3a13039c2da3868a61be4ee9f17d8ae380a35a97e506972170"

  bottle do
    sha256 "982576be0136e46016643da0efdb44e3ab201263b2a43433448821c19fb9edd4" => :el_capitan
    sha256 "142edfec5f84958bdb27866e3a826f9b580a4ae07bfd805c766ab6a9a368e34f" => :yosemite
    sha256 "851e007f3edaa58fc00d9c67aeed2ab5a8b9a1bad608dc3e5d76732cc35c593f" => :mavericks
    sha256 "32ef44141d7dff2995ea0a692a3861ee9049a37a1254a3978c7dc8283c258476" => :mountain_lion
  end

  conflicts_with "ganglia", :because => "both install `gstat` binaries"
  conflicts_with "idutils", :because => "both install `gid` and `gid.1`"
  conflicts_with "aardvark_shell_utils", :because => "both install `realpath` binaries"

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

  depends_on "gmp" => :optional

  def install
    system "./bootstrap" if build.head?
    args = %W[
      --prefix=#{prefix}
      --program-prefix=g
    ]
    args << "--without-gmp" if build.without? "gmp"
    system "./configure", *args
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
