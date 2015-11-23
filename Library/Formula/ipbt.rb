class Ipbt < Formula
  desc "Program for recording a UNIX terminal session"
  homepage "http://www.chiark.greenend.org.uk/~sgtatham/ipbt/"
  url "http://www.chiark.greenend.org.uk/~sgtatham/ipbt/ipbt-20141026.2197432.tar.gz"
  sha256 "151da94da378cc88e979df8eb5f9a05c4e663bd1299c191d24c10128bae879b0"

  bottle do
    cellar :any
    sha256 "31cb431e2612d8eb4c1fc1653d675c2d6789c74acf3fbe09367df8e0b5350a8e" => :yosemite
    sha256 "d5ae41af0fa56f3cfb1e5fef2e17fb20fc2d18b2b1c11ecb0f0d57fd97edfc58" => :mavericks
    sha256 "2f6782c8fa4d72545b367c6a210d58bffa87db3e36c8d66ac28934183a6d4547" => :mountain_lion
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
