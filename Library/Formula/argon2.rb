class Argon2 < Formula
  desc "Password hashing library and CLI utility"
  homepage "https://github.com/P-H-C/phc-winner-argon2"
  url "https://github.com/P-H-C/phc-winner-argon2/archive/20151206.tar.gz"
  sha256 "29f9eb6d84bfe29604c48830432aa030e96158d66e85a2c83b115e29eb025e85"

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
