class Unyaffs < Formula
  homepage "https://github.com/ehlers/unyaffs"
  url "https://github.com/ehlers/unyaffs/archive/0.9.6.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/u/unyaffs/unyaffs_0.9.6.orig.tar.gz"
  sha256 "33c46419ab5cc5290f3b780f0cc9d93729962799f5eb7cecb9b352b85939fbbf"

  head "https://github.com/ehlers/unyaffs.git"

  def install
    system "make"
    bin.install "unyaffs"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unyaffs -V")
  end
end
