class Argon2 < Formula
  desc "Password hashing library and CLI utility"
  homepage "https://github.com/P-H-C/phc-winner-argon2"
  url "https://github.com/P-H-C/phc-winner-argon2/archive/20151206.tar.gz"
  sha256 "29f9eb6d84bfe29604c48830432aa030e96158d66e85a2c83b115e29eb025e85"

  bottle do
    cellar :any
    sha256 "5aa9e252affd4fd146b9cc23c563c8cb4ee03a13df507bf6b0dff00badf8997d" => :el_capitan
    sha256 "d35eec9e5db9398779c13cb16ffb6b1fa3e91a9032c2e32c302cb4cc7c2d513a" => :yosemite
    sha256 "a9bc8e51ebc587f28f6d9e1024d74375800b9ad7711a394c18439ada7700d25e" => :mavericks
  end

  def install
    system "make"
    include.install "src/argon2.h"
    lib.install "libargon2.dylib"
    bin.install "argon2"
  end

  test do
    assert_equal "$argon2i$m=65536,t=2,p=4$c29tZXNhbHQAAAAAAAAAAA$Q38e04oLanBHl/MHZra3ypCikyWHhVYRVbekTeGl03o\n",
      pipe_output("echo -n password | #{bin}/argon2 somesalt -t 2 -m 16 -p 4 | grep Encoded | awk '{print $2}'")
  end
end
