class Ciso < Formula
  desc "command-line utility to compress PSP iso files"
  homepage "https://github.com/jamie/ciso"
  url "https://github.com/jamie/ciso/archive/v1.0.2.tar.gz"
  sha256 "77a9bb615ca8918ef81f21328cb4fdc58f4cdd854cb11c16bb50a7d4d1625c09"

  def install
    system "make"
    bin.install "ciso"
  end

  test do
    system "ciso"
  end
end
