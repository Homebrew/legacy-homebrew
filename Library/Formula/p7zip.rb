class P7zip < Formula
  desc "7-Zip (high compression file archiver) implementation"
  homepage "http://p7zip.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/p7zip/p7zip/15.09/p7zip_15.09_src_all.tar.bz2"
  sha256 "8783acf747e210e00150f7311cc06c4cd8ecf7b0c27b4adf2194284cc49b4d6f"

  bottle do
    cellar :any_skip_relocation
    sha256 "f511842f500b491038e1ba33846b9e740d6b05806e713df89d166f81b5577c22" => :el_capitan
    sha256 "d826d0523d22bdb8d5d3215057d9dadc6d8a087f2c6df2906b8639272dd0f2aa" => :yosemite
    sha256 "c42705fef2c52ce8d2244d4e953d43d7276f4c884aa9ed8349680d9ff7d18916" => :mavericks
  end

  def install
    mv "makefile.macosx_llvm_64bits", "makefile.machine"
    system "make", "all3",
                   "CC=#{ENV.cc} $(ALLFLAGS)",
                   "CXX=#{ENV.cxx} $(ALLFLAGS)"
    system "make", "DEST_HOME=#{prefix}",
                   "DEST_MAN=#{man}",
                   "install"
  end
end
