require "formula"

class Spin < Formula
  homepage "http://spinroot.com/spin/whatispin.html"
  url "http://spinroot.com/spin/Src/spin642.tar.gz"
  version "6.4.2"
  sha1 "a3a7db806ebcc9f645cf4b61a167145c3d242242"

  bottle do
    cellar :any
    sha1 "388caba593c8f6224513d16b7a307358e5745ec8" => :mavericks
    sha1 "7979b9dc5722eaeebb8e2e98e4a4d0495bedc775" => :mountain_lion
    sha1 "bd24c1f818b6460e90dada5adc75aa58ef0d5c4c" => :lion
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
