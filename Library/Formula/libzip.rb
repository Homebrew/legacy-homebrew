class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "http://www.nih.at/libzip/"
  url "http://www.nih.at/libzip/libzip-0.11.2.tar.gz"
  sha256 "83db1fb43a961ff7d1d1b50e1c6bea09c67e6af867686d1fc92ecb7dc6cf98d5"

  bottle do
    cellar :any
    revision 2
    sha256 "45d2813d47e8a0989651d844cd597abdb06d411549bb6db9c3fa8541debfc809" => :el_capitan
    sha1 "714257f1e187a42f11c50c8f777d79d8beba28c6" => :yosemite
    sha1 "65b31e70e363879aad9f8d1845e17bf7f2dcaeb3" => :mavericks
    sha1 "f1571198224aa96ea539e282c24097ee4d9096d6" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "CXX=#{ENV.cxx}",
                          "CXXFLAGS=#{ENV.cflags}"
    system "make", "install"
  end

  test do
    touch "file1"
    system "zip", "file1.zip", "file1"
    touch "file2"
    system "zip", "file2.zip", "file1", "file2"
    assert_match /\+.*file2/, shell_output("#{bin}/zipcmp -v file1.zip file2.zip", 1)
  end
end
