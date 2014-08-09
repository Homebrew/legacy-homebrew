require "formula"

class GnuTar < Formula
  homepage "http://www.gnu.org/software/tar/"
  url "http://ftpmirror.gnu.org/tar/tar-1.28.tar.gz"
  mirror "http://ftp.gnu.org/gnu/tar/tar-1.28.tar.gz"
  sha1 "cd30a13bbfefb54b17e039be7c43d2592dd3d5d0"

  bottle do
    sha1 "3df9bf4cfa0fc347996ee8877b20b3b6062046a4" => :mavericks
    sha1 "43a8b742e543f64f42042df26505adaff1860b21" => :mountain_lion
    sha1 "8f68e3ef6195270056223f15b011d7249684480d" => :lion
  end

  # autoconf/automake can be removed when the patch is merged upstream.
  depends_on "autoconf" => :build
  depends_on "automake" => :build

  # Fix for xattrs bug causing build failures on OS X:
  # https://lists.gnu.org/archive/html/bug-tar/2014-08/msg00001.html
  patch :p1 do
    url "https://raw.githubusercontent.com/DomT4/patch-mayhem/master/0001-xattrs-fix-bug-in-configure.patch"
    sha1 "d8d9f9f5862fa1c1468a914e609daaf57accf3d2"
  end

  def install
    args = ["--prefix=#{prefix}", "--mandir=#{man}"]
    args << "--program-prefix=g"

    # autoreconf can be removed when the patch is merged upstream.
    system "autoreconf"
    system "./configure", *args
    system "make", "install"

    # Symlink the executable into libexec/gnubin as "tar"
    (libexec/"gnubin").install_symlink bin/"gtar" => "tar"
  end

  def caveats; <<-EOS.undent
    gnu-tar has been installed as "gtar".

    If you really need to use it as "tar", you can add a "gnubin" directory
    to your PATH from your bashrc like:

        PATH="#{opt_libexec}/gnubin:$PATH"
    EOS
  end
end
