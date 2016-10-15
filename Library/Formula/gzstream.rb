require "formula"

class Gzstream < Formula
  homepage "http://www.cs.unc.edu/Research/compgeom/gzstream/"
  url "http://www.cs.unc.edu/Research/compgeom/gzstream/gzstream.tgz"
  sha1 "3cdd797c7e5a10408eb664aca9666525fe00652a"
  version "1.5"

  def install
    system "make", "clean" # remove precompiled files
    system "make"
    prefix.install "README",  "version", "index.html", "COPYING.LIB", "logo.gif"
    (prefix/"examples").install "test_gunzip.C", "test_gzip.C"
    include.install "gzstream.h"
    lib.install "libgzstream.a"
  end

  test do
    system ENV.cxx, "#{prefix}/examples/test_gunzip.C", "-lgzstream", "-lz"
    system ENV.cxx, "#{prefix}/examples/test_gzip.C", "-lgzstream", "-lz"
  end
end
