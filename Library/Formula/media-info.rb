require "formula"

class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/0.7.75/MediaInfo_CLI_0.7.75_GNU_FromSource.tar.bz2"
  version "0.7.75"
  sha256 "98f3a7ba9daf77e3df2fd308811e20ef6f87c6471fce8d6fe611b56668623f0d"

  bottle do
    cellar :any
    sha256 "775f21604db1c9f4d4158d6310970799e040443e3aed15c2caa99f4f6072d618" => :yosemite
    sha256 "7d812960fc07dc8b5e11438822336c24d5191eaa0d6661418e536ac2584c13f7" => :mavericks
    sha256 "d50e07286760c0e75e49738e08d8563000b6b5a6d2475604309ea2093dada7af" => :mountain_lion
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
