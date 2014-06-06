require "formula"

class Xorriso < Formula
  homepage "https://www.gnu.org/software/xorriso/"
  url "http://ftpmirror.gnu.org/xorriso/xorriso-1.3.6.pl01.tar.gz"
  mirror "https://ftp.gnu.org/gnu/xorriso/xorriso-1.3.6.pl01.tar.gz"
  sha1 "b9d8f38726993e707c7bb512c73e591644905e9c"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/xorriso", "--help"
  end
end
