require 'formula'

class Agedu < Formula
  homepage 'http://www.chiark.greenend.org.uk/~sgtatham/agedu/'
  url 'http://www.chiark.greenend.org.uk/~sgtatham/agedu/agedu-r9723.tar.gz'
  version 'r9723'
  sha1 '81d9a598993625c520cfdb05686e07aee0d4ed3f'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/agedu", "-s", "."
    File.exist? "agedu.dat"
  end
end
