require "formula"

class Spin < Formula
  desc "Spin model checker"
  homepage "http://spinroot.com/spin/whatispin.html"
  url "http://spinroot.com/spin/Src/spin642.tar.gz"
  version "6.4.2"
  sha1 "a3a7db806ebcc9f645cf4b61a167145c3d242242"

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
