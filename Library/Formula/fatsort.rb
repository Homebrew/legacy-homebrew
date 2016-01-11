class Fatsort < Formula
  desc "Sorts FAT16 and FAT32 partitions"
  homepage "http://fatsort.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/fatsort/fatsort-1.3.365.tar.gz"
  sha256 "77acc374b189e80e3d75d3508f3c0ca559f8030f1c220f7cfde719a4adb03f3d"

  depends_on "help2man"

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "src/fatsort"
    man1.install "man/fatsort.1"
  end
end
