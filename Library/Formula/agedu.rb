require 'formula'

class Agedu < Formula
  homepage 'http://www.chiark.greenend.org.uk/~sgtatham/agedu/'
  url 'http://www.chiark.greenend.org.uk/~sgtatham/agedu/agedu-r10126.tar.gz'
  version 'r10126'
  sha1 '4438ae698b626cba5ce061ed3ae5eefa5bfb1c50'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/agedu", "-s", "."
    assert File.exist?("agedu.dat")
  end
end
