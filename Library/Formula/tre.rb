class Tre < Formula
  desc "Lightweight, POSIX-compliant regular expression (regex) library"
  homepage "http://laurikari.net/tre/"
  url "http://laurikari.net/tre/tre-0.8.0.tar.bz2"
  sha256 "8dc642c2cde02b2dac6802cdbe2cda201daf79c4ebcbb3ea133915edf1636658"

  bottle do
    cellar :any
    sha256 "6fada15a2fd1c5905f8ed45d3c966da5e14efeb10522f82c26d2a23a918abaad" => :yosemite
    sha256 "c57f9bfa724cd20843a672f5e8bd384e05e65bac062dd7d7b676db9b1c11f998" => :mavericks
    sha256 "1159edaece87806b8141cb351d896641b6de1667b0f62d6214ff0412ffae7fc4" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "brow", pipe_output("#{bin}/agrep -1 brew", "brow", 0)
  end
end
