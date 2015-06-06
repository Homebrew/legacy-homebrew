require "formula"

class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/0.7.74/MediaInfo_CLI_0.7.74_GNU_FromSource.tar.bz2"
  version "0.7.74"
  sha1 "89cf4745e3d9725bf109976a933f36af2a3aa36a"

  bottle do
    cellar :any
    sha256 "a3fb613a28c28aab0a792bd3a13da9ad8715ef2d17421ebc9154f73ec82ae57d" => :yosemite
    sha256 "7f4f0ef118462e60579754016fa3a64ee81bd8d8f81fd776ff7225fa0a62c43c" => :mavericks
    sha256 "e69fce673bf6245f7eea82e8a47d39d08a708cdab9f1f1898e235c5e08c0b755" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  # fails to build against Leopard's older libcurl
  depends_on "curl" if MacOS.version < :snow_leopard

  def install
    cd "ZenLib/Project/GNU/Library" do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make"
    end

    cd "MediaInfoLib/Project/GNU/Library" do
      args = ["--disable-debug",
              "--disable-dependency-tracking",
              "--with-libcurl",
              "--prefix=#{prefix}"]
      system "./configure", *args
      system "make install"
    end

    cd "MediaInfo/Project/GNU/CLI" do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make install"
    end
  end
end
