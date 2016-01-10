class Byacc < Formula
  desc "(Arguably) the best yacc variant"
  homepage "http://invisible-island.net/byacc/byacc.html"
  url "ftp://invisible-island.net/byacc/byacc-20141128.tgz"
  sha256 "f517fc21f08c1a1f010177357df58fc64eb1131011e5dcd48c19fe44c47198d0"

  bottle do
    cellar :any_skip_relocation
    sha256 "21dacda27da29077ee9c0bc1d892a0b09c119b4233e4731488a681b87828333b" => :el_capitan
    sha256 "2aacd30dce05fc6e562149d7ec703cb458ce2b2a1fe77fa0602771cb2c12318f" => :yosemite
    sha256 "96bebc234ef0c1d7d69a9c84df6106f1352dddf6523194acd251d7d1127c581d" => :mavericks
    sha256 "c92db788a5f26ff6c0d50ff5bba2b2d1bb2c715c9ceab0a638874774959918f1" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--program-prefix=b", "--prefix=#{prefix}", "--man=#{man}"
    system "make", "install"
  end

  test do
    system bin/"byacc", "-V"
  end
end
