require "formula"

class LcdfTypetools < Formula
  homepage "http://www.lcdf.org/type/"
  url "http://www.lcdf.org/type/lcdf-typetools-2.101.tar.gz"
  sha256 "bbbaddb3d9681ba93de400c876b76412a370e1a1c94fe4e71393777759b214a5"

  conflicts_with "open-mpi", :because => "both install same set of binaries."

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-kpathsea"
    system "make install"
  end
end
