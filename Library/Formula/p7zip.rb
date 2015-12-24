class P7zip < Formula
  desc "7-Zip (high compression file archiver) implementation"
  homepage "http://p7zip.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/p7zip/p7zip/15.09/p7zip_15.09_src_all.tar.bz2"
  sha256 "8783acf747e210e00150f7311cc06c4cd8ecf7b0c27b4adf2194284cc49b4d6f"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "ca8c3e999af9b2dcd7ba4889c94111b0ab8971eb4234f4935a5d0d644ec755d8" => :el_capitan
    sha256 "d92cf7a481836bfc5b2292d636d45333b1946b82835510329eb0aa17483978ed" => :yosemite
    sha256 "c621e245f8b0912e135861756e3b3f443858f3d8291887d2438acbf3c09f4ee3" => :mavericks
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
