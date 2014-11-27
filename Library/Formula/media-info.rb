require "formula"

class MediaInfo < Formula
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/0.7.71/MediaInfo_CLI_0.7.71_GNU_FromSource.tar.bz2"
  version "0.7.71"
  sha1 "d650d3202d1aa2b8af02a7ca53e04ee2c0f227d0"

  bottle do
    cellar :any
    sha1 "93961776e55ad1c47a989f921426b8984ec5ae92" => :yosemite
    sha1 "25bdcd8df95d77095eb304ed4633ddea6c6dee0c" => :mavericks
    sha1 "e580796e61e1f30b05ac376089a3ec000b416a47" => :mountain_lion
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
