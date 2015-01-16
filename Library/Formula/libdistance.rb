class Libdistance < Formula
  homepage "http://monkey.org/~jose/software/libdistance/"
  url "http://monkey.org/~jose/software/libdistance/libdistance-0.2.2.tar.gz"
  sha1 "d516e5f24ae55bcbbf93a4d14c6a53914e5b3a0a"

  def install
    # The build system is incredibly simple.
    system "make"
    include.install "distance.h"
    lib.install "libdistance.a"
  end
end
