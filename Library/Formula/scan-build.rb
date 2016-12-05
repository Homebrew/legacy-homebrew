class ScanBuild < Formula
  desc "Clang Static Analyzer"
  homepage "http://clang-analyzer.llvm.org/scan-build.html"
  url "http://clang-analyzer.llvm.org/downloads/checker-278.tar.bz2"
  sha256 "f7180d530eceafc006f30461895ac23033b3b432c41363a185f2234535a09860"

  def install
    prefix.install Dir["*"]
  end

  test do
    system "#{bin}/scan-build", "--help"
  end
end
