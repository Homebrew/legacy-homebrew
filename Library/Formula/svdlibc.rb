class Svdlibc < Formula
  desc "C library to perform singular value decomposition"
  homepage "https://tedlab.mit.edu/~dr/SVDLIBC/"
  url "https://tedlab.mit.edu/~dr/SVDLIBC/svdlibc.tgz"
  version "1.4"
  sha256 "aa1a49a95209801803cc2d9f8792e482b0e8302da8c7e7c9a38e25e5beabe5f8"

  bottle do
    cellar :any_skip_relocation
    revision 3
    sha256 "f4e320bb8555cfed8d39a134153df533a3b921ae01827728cba36c6217bb85be" => :el_capitan
    sha256 "da1b02f2d5758322ddcfc30b0513249f31dd1aad96fd2f3377e9edc301f7c686" => :yosemite
    sha256 "3be9467077ff9035209957c3c8111b3a50be89cce873726119efba60856eca38" => :mavericks
  end

  def install
    # make only builds - no configure or install targets, have to copy files manually
    system "make HOSTTYPE=target"
    include.install "svdlib.h"
    lib.install "target/libsvd.a"
    bin.install "target/svd"
  end
end
