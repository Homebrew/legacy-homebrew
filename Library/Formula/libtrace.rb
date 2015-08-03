class Libtrace < Formula
  desc "Library for trace processing supporting multiple inputs"
  homepage "http://research.wand.net.nz/software/libtrace.php"
  url "http://research.wand.net.nz/software/libtrace/libtrace-3.0.22.tar.bz2"
  sha256 "b8bbaa2054c69cc8f93066143e2601c09c8ed56e75c6e5e4e2c115d07952f8f8"

  bottle do
    sha256 "3b4b9e487c60283fa6de2def172493fbc5e78a856174ccfd8a2850adcf734dcc" => :yosemite
    sha256 "1ad2c47d6b52a7b40760242f40e40f28730ef3baa26868a1f9300fece0532e0f" => :mavericks
    sha256 "1e1115e10b3c226a49a3c29187327ba39cc5a83941736ed48a5cf866fae3da69" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
