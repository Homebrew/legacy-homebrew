class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://www.snort.org/downloads/snort/daq-2.0.5.tar.gz"
  sha256 "7704b5db858732142586f5043deb0733e2c396535c83081e918fb6993258bc6d"

  bottle do
    cellar :any
    sha256 "04ee508c881d80e6d115a3f7fcd8c45ec7405c90a9a2a60cfa2e06f75030ee2a" => :yosemite
    sha256 "49b01b6adb0cd5757a919afb84d25c0ba2644df35178c5024f31f9ca9f676821" => :mavericks
    sha256 "1fad31d21b32ad21c18ed686e8043d65e629a9af16e5cc72774ef7677199b7a6" => :mountain_lion
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
