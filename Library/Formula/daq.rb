class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://www.snort.org/downloads/snort/daq-2.0.5.tar.gz"
  sha256 "7704b5db858732142586f5043deb0733e2c396535c83081e918fb6993258bc6d"

  bottle do
    cellar :any
    sha1 "f3fb9c1e17455a6172cf1f43c867675115c2c990" => :yosemite
    sha1 "d257544110abe1872795e492c611cfa3d825734a" => :mavericks
    sha1 "64346e0563f43fb97fbe2d71d6359d5131351e97" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert File.exist? "#{include}/daq.h"
  end
end
