class Dialog < Formula
  desc "Display user-friendly dialog boxes from shell scripts"
  homepage "http://invisible-island.net/dialog/"
  url "ftp://invisible-island.net/dialog/dialog-1.2-20150528.tgz"
  mirror "https://fossies.org/linux/misc/dialog-1.2-20150528.tgz"
  sha256 "a8cd7a66bdb41e53a3145cbb0eb370c5ce7300fe0e9ad6d3e8d3b9e16ff16418"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6e5a5027473b84bee4d5332e4bd014206b0699ffe126812c237f2866e5269ea" => :el_capitan
    sha256 "f1f50b2dc04d66fbff91db59d9e1fecfee3f54d9ec33614015582745e4d6dbd8" => :yosemite
    sha256 "fd3feefe57a2bf2f0592e8cc818e4510a71f5ad39989395eb2ec5d24bf8ee93e" => :mavericks
    sha256 "6da0c61033ca4eb531f943f12f61dd4e16fd92f6408a1e247494e6af6b22fae4" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install-full"
  end
end
