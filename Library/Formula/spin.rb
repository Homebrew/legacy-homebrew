require 'formula'

class Spin < Formula
  homepage 'http://spinroot.com/spin/whatispin.html'
  url 'http://spinroot.com/spin/Src/spin625.tar.gz'
  version '6.2.5'
  sha1 '6034126bccd7b08fc7ff06d81f69b5a0ada7644f'

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
