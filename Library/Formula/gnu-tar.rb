class GnuTar < Formula
  desc "GNU version of the tar archiving utility"
  homepage "https://www.gnu.org/software/tar/"
  url "http://ftpmirror.gnu.org/tar/tar-1.28.tar.gz"
  mirror "https://ftp.gnu.org/gnu/tar/tar-1.28.tar.gz"
  sha256 "6a6b65bac00a127a508533c604d5bf1a3d40f82707d56f20cefd38a05e8237de"

  option "with-default-names", "Do not prepend 'g' to the binary"

  bottle do
    revision 3
    sha256 "e454d4acb5d791a70b9f00658c1f2397f7a52e28657ea55a67b4f1d469222d98" => :el_capitan
    sha256 "eacc46c8c80c5223cf77ff88ff16dc698b6e30927f7f3599b3af4222050d5a0c" => :yosemite
    sha256 "b21d9afff94eba7d94b7e3fb886ab781e6bd3e3acc1615092788143b08384f49" => :mavericks
  end

  # Fix for xattrs bug causing build failures on OS X:
  # https://lists.gnu.org/archive/html/bug-tar/2014-08/msg00001.html
  patch do
    url "https://gist.githubusercontent.com/mistydemeo/10fbae8b8441359ba86d/raw/e5c183b72036821856f9e82b46fba6185e10e8b9/gnutar-configure-xattrs.patch"
    sha256 "f2e56bb8afd1c641a7e5b81e35fdbf36b6fb66434b1e35caa8b55196b30c3ad9"
  end

  def install
    # Work around unremovable, nested dirs bug that affects lots of
    # GNU projects. See:
    # https://github.com/Homebrew/homebrew/issues/45273
    # https://github.com/Homebrew/homebrew/issues/44993
    # This is thought to be an el_capitan bug:
    # http://lists.gnu.org/archive/html/bug-tar/2015-10/msg00017.html
    if MacOS.version == :el_capitan
      ENV["gl_cv_func_getcwd_abort_bug"] = "no"
    end

    args = ["--prefix=#{prefix}", "--mandir=#{man}"]
    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make", "install"

    # Symlink the executable into libexec/gnubin as "tar"
    (libexec/"gnubin").install_symlink bin/"gtar" => "tar" if build.without? "default-names"
  end

  def caveats
    if build.without? "default-names" then <<-EOS.undent
      gnu-tar has been installed as "gtar".

      If you really need to use it as "tar", you can add a "gnubin" directory
      to your PATH from your bashrc like:

          PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    tar = build.with?("default-names") ? bin/"tar" : bin/"gtar"
    (testpath/"test").write("test")
    system tar, "-czvf", "test.tar.gz", "test"
    assert_match /test/, shell_output("#{tar} -xOzf test.tar.gz")
  end
end
