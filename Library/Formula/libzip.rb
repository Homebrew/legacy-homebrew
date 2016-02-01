class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "http://www.nih.at/libzip/"
  url "http://www.nih.at/libzip/libzip-1.1.tar.xz"
  sha256 "13b0b49637f9857ab8ba7335f529e26d02aadacf2074bf0c9b28889a0fc83b24"

  bottle do
    cellar :any
    sha256 "a247edc8d20ee2472c9f94040595088c124c02bcd024fe3980b7c751fd98d9bb" => :el_capitan
    sha256 "4cb430d47617578511643326a4ca95c32416f6a698a826a33938aa444b6cfcf2" => :yosemite
    sha256 "71298db872b42939f13c862c246ee1d1dc2925534551f8de2ba06d9dc37c560b" => :mavericks
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
