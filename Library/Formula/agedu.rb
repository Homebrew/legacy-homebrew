require 'formula'

class Agedu < Formula
  homepage 'http://www.chiark.greenend.org.uk/~sgtatham/agedu/'
  url 'http://www.chiark.greenend.org.uk/~sgtatham/agedu/agedu-r10126.tar.gz'
  version 'r10126'
  sha1 'a8fc32bd78e79f4c65e8d87140a243dcccda3a8d'

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
