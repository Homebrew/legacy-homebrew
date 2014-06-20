require "formula"

class Spin < Formula
  homepage "http://spinroot.com/spin/whatispin.html"
  url "http://spinroot.com/spin/Src/spin632.tar.gz"
  version "6.3.2"
  sha1 "835f4d77e9f4c1c4c697b0d548606a579bd4b5df"

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
