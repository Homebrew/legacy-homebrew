require "formula"

class Gzstream < Formula
  homepage "http://www.cs.unc.edu/Research/compgeom/gzstream/"
  url "http://www.cs.unc.edu/Research/compgeom/gzstream/gzstream.tgz"
  sha1 "3cdd797c7e5a10408eb664aca9666525fe00652a"
  version "1.5"
  depends_on "zlib"

  def install
    system "make", "clean" # remove precompiled files
    system "make"
    prefix.install "README",  "version", "index.html", "COPYING.LIB", "logo.gif"
    include.install "gzstream.h"
    lib.install "libgzstream.a"
  end
end
