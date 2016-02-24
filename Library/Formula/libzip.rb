class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "http://www.nih.at/libzip/"
  url "http://www.nih.at/libzip/libzip-1.1.tar.xz"
  sha256 "13b0b49637f9857ab8ba7335f529e26d02aadacf2074bf0c9b28889a0fc83b24"

  bottle do
    cellar :any
    sha256 "544666849b04c846203c55c6b70a4412cd49e10ae7b7250f01fb1fd78b7ce1e9" => :el_capitan
    sha256 "2fb035f82a334d4d712a1597200796a9e84f7bc3192f2405df4f20542f47eb3c" => :yosemite
    sha256 "7947355b5093939e74f689075942060bf77ffdbb33f60753aa1c7081684e68ec" => :mavericks
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
