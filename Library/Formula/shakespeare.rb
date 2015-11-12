class Shakespeare < Formula
  desc "Write programs in Shakespearean English"
  homepage "http://shakespearelang.sourceforge.net/"
  url "http://shakespearelang.sf.net/download/spl-1.2.1.tar.gz"
  sha256 "1206ef0a2c853b8b40ca0c682bc9d9e0a157cc91a7bf4e28f19ccd003674b7d3"

  depends_on "flex" if MacOS.version >= :mountain_lion

  def install
    system "make", "install"
    bin.install "spl/bin/spl2c"
    include.install "spl/include/spl.h"
    lib.install "spl/lib/libspl.a"
  end
end
