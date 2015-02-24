class GnuTar < Formula
  homepage "http://www.gnu.org/software/tar/"
  url "http://ftpmirror.gnu.org/tar/tar-1.28.tar.gz"
  mirror "http://ftp.gnu.org/gnu/tar/tar-1.28.tar.gz"
  sha1 "cd30a13bbfefb54b17e039be7c43d2592dd3d5d0"

  option "with-default-names", "Do not prepend 'g' to the binary"

  bottle do
    revision 2
    sha1 "bc61f3210e6f8adaade8abe7e8bed4542ead62e2" => :yosemite
    sha1 "01e82dddbbadb8a40af90f1f844cce3684a19399" => :mavericks
    sha1 "63268147e47588ccbb33be80e3484611bfacc2f4" => :mountain_lion
  end

  # Fix for xattrs bug causing build failures on OS X:
  # https://lists.gnu.org/archive/html/bug-tar/2014-08/msg00001.html
  patch do
    url "https://gist.githubusercontent.com/mistydemeo/10fbae8b8441359ba86d/raw/e5c183b72036821856f9e82b46fba6185e10e8b9/gnutar-configure-xattrs.patch"
    sha1 "55d570de077eb1dd30b1e499484f28636fbda882"
  end

  def install
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
    (testpath/"test").write("test")
    system "#{bin}/gtar", "-czvf", "test.tar.gz", "test"
    assert_match /test/, shell_output("#{bin}/gtar -xOzf test.tar.gz")
  end
end
