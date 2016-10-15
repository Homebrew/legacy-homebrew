require "formula"

class Yodl < Formula
  homepage "http://yodl.sourceforge.net/"
  url "http://downloads.sourceforge.net/project/yodl/yodl/3.03.0/yodl_3.03.0.orig.tar.gz"
  sha1 "bf244ab9b14024db98bee417c2055196237fab0b"

  option "with-manual", "Use latex to create an optional manual during build."

  depends_on "icmake" => :build
  depends_on :tex if build.with? "manual"

  def patches
    # Disables debugging and removes hardlink to icmake.
    "https://gist.github.com/FloFra/8510468/raw/e599e9030ab3e39a12295522df489c010a337a3d/yodl_build_mac.patch"
  end

  def install
    inreplace "INSTALL.im", %-"/usr"-, %-"#{prefix}"-

    system "./build", "programs"
    system "./build", "man"

    system "./build", "manual" if build.with? 'manual'

    system "./build", "macros"


    system "./build", "install", "programs", "/"
    system "./build", "install", "man", "/"

    system "./build", "install", "manual", "/" if build.with? 'manual'

    system "./build", "install", "macros", "/"
    system "./build", "install", "docs", "/"
  end
end
