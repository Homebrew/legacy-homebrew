require "formula"

class Rkflashtool < Formula
  homepage "https://sourceforge.net/projects/rkflashtool/"
  url "https://downloads.sourceforge.net/project/rkflashtool/rkflashtool-5.1/rkflashtool-5.1-src.tar.bz2"
  sha1 "5b786298376649a2d44069d5aa7053318b983fa1"

  head "git://git.code.sf.net/p/rkflashtool/Git"

  bottle do
    cellar :any
    sha1 "a51793a60e27ea73735ccf83a6386f809c34faf2" => :mavericks
    sha1 "cd08e68dc4fdb0f56fb10b77f78ca13476ac8a63" => :mountain_lion
    sha1 "4b7f416b735845a43c5a0ed2086d07f2b1a751b1" => :lion
  end

  depends_on "libusb"

  # Add file 'version.h' that has been forgotten in the tarball
  resource "version" do
    url "https://downloads.sourceforge.net/project/rkflashtool/rkflashtool-5.1/version.h"
    sha1 "eaf56bbcaebb6f169233e6792459c62186f65e06"
  end

  def install
    resource("version").stage { buildpath.install "version.h" } if build.stable?
    system "make"

    # No 'install' method found in Makefile
    bin.install "rkflashtool", "rkcrc", "rkmisc", "rkpad",
      "rkparameters", "rkparametersblock", "rkunpack", "rkunsign"
  end

  test do
    (testpath/"input.file").write "ABCD"
    system bin/"rkcrc", "input.file", "output.file"
    assert_equal "ABCD\264\366\a\t", `cat output.file`
  end
end
