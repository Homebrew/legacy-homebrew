require 'formula'

class Agedu < Formula
  homepage 'http://www.chiark.greenend.org.uk/~sgtatham/agedu/'
  url 'http://www.chiark.greenend.org.uk/~sgtatham/agedu/agedu-r10126.tar.gz'
  version 'r10126'
  sha1 'f4d2ea0694ec7813005002fe11a15cc2e26b269f'

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
