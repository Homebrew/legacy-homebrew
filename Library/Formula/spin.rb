class Spin < Formula
  desc "Spin model checker"
  homepage "http://spinroot.com/spin/whatispin.html"
  url "http://spinroot.com/spin/Src/spin642.tar.gz"
  version "6.4.2"
  sha256 "d1f3ee841db0da7ba02fe1a04ebd02d316c0760ab8125616d7d2ff46f1c573e5"

  bottle do
    cellar :any
    sha1 "2dc693103db81f07a33b438c20c0177eb0d9baf8" => :yosemite
    sha1 "33205462fcecedf4c5e36f76abd718157e1cbeed" => :mavericks
    sha1 "825e8d9e41c6a148d3b79f14e5d2f53c25d198ff" => :mountain_lion
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
