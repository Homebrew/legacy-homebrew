class Topgit < Formula
  desc "Git patch queue manager"
  homepage "https://github.com/greenrd/topgit"
  url "https://github.com/greenrd/topgit/archive/topgit-0.9.tar.gz"
  sha256 "24b55f666e8d88ebf092a1df365492a659210a750c0793acb0c8560694203dfd"

  def install
    system "make", "install", "prefix=#{prefix}"
  end
end
