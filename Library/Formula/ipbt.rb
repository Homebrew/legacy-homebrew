class Ipbt < Formula
  desc "Program for recording a UNIX terminal session"
  homepage "http://www.chiark.greenend.org.uk/~sgtatham/ipbt/"
  url "http://www.chiark.greenend.org.uk/~sgtatham/ipbt/ipbt-20141026.2197432.tar.gz"
  sha256 "151da94da378cc88e979df8eb5f9a05c4e663bd1299c191d24c10128bae879b0"

  bottle do
    cellar :any
    sha1 "94e2a914cf9064bfe6efd9657d207ea40ca79d57" => :yosemite
    sha1 "3cdaf9b8d08e0df8c07abf5b5a1f032bb3ea9247" => :mavericks
    sha1 "a8069949e4cc1e4a6cf7124ac3e2ecc3488a33ee" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "#{bin}/ipbt"
  end
end
