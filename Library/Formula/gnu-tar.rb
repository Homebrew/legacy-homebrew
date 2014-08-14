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

  # Fix for xattrs bug causing build failures on OS X:
  # https://lists.gnu.org/archive/html/bug-tar/2014-08/msg00001.html
  patch :p1 do
    url "https://gist.githubusercontent.com/mistydemeo/10fbae8b8441359ba86d/raw/e5c183b72036821856f9e82b46fba6185e10e8b9/gnutar-configure-xattrs.patch"
    sha1 "55d570de077eb1dd30b1e499484f28636fbda882"
  end

  def install
    args = ["--prefix=#{prefix}", "--mandir=#{man}"]
    args << "--program-prefix=g"

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
