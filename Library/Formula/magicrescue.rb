class Magicrescue < Formula
  desc "Magic Rescue extracts files of known types from a block device."
  homepage "http://www.itu.dk/people/jobr/magicrescue/"
  url "http://www.itu.dk/people/jobr/magicrescue/release/magicrescue-1.1.9.tar.gz"
  sha256 "a920b174efd664afe9760a43700588c9c5e6182cb13d7421e07ab613bceeb3c7"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
  end
end
