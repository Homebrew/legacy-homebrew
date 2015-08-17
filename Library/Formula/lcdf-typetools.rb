class LcdfTypetools < Formula
  desc "Manipulate OpenType and multiple-master fonts"
  homepage "http://www.lcdf.org/type/"
  url "http://www.lcdf.org/type/lcdf-typetools-2.104.tar.gz"
  sha256 "d7985458ead0850cb9549ff1d619ffc18da5d7be892be5e1fce6048d510f0fff"

  conflicts_with "open-mpi", :because => "both install same set of binaries."

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-kpathsea"
    system "make", "install"
  end
end
