class Bomutils < Formula
  homepage "https://hogliux.github.io/bomutils/"
  url "https://github.com/hogliux/bomutils/archive/0.2.tar.gz"
  sha256 "fb1f4ae37045eaa034ddd921ef6e16fb961e95f0364e5d76c9867bc8b92eb8a4"

  head "https://github.com/hogliux/bomutils.git"

  def install
    system "make", "install", "CXX=#{ENV.cxx}", "PREFIX=#{prefix}"
  end
end
