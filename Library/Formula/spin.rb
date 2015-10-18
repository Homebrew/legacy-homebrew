class Spin < Formula
  desc "Spin model checker"
  homepage "https://spinroot.com/spin/whatispin.html"
  url "https://spinroot.com/spin/Src/spin642.tar.gz"
  version "6.4.2"
  sha256 "d1f3ee841db0da7ba02fe1a04ebd02d316c0760ab8125616d7d2ff46f1c573e5"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "f83fa245ef9988d38eac9e7f125fa965d1ed53463b550d8606435997d5e0da18" => :el_capitan
    sha256 "07ac05a68769acdb0d4be2085ca2f2bca906066af85d1e2730bbed834a7d46d3" => :yosemite
    sha256 "cb0049c50da45aafad43683a9ab813e6c3dc89a4d76890c44da3e5992a70f9b6" => :mavericks
  end

  fails_with :llvm do
    build 2334
  end

  def install
    ENV.deparallelize

    cd "Src#{version}" do
      system "make"
      bin.install "spin"
    end

    bin.install "iSpin/ispin.tcl" => "ispin"
    man1.install "Man/spin.1"
  end
end
