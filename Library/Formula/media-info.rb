require "formula"

class MediaInfo < Formula
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/0.7.72/MediaInfo_CLI_0.7.72_GNU_FromSource.tar.bz2"
  version "0.7.72"
  sha1 "e0f495f8c589ec2dc1c84011ddbf8946f28ab186"

  bottle do
    cellar :any
    sha1 "aa9ad2b2c7f6a813041f85a228fb92539ecb9841" => :yosemite
    sha1 "5a4712da44a81a22f4f3d0a61ec0f590bcbc4d85" => :mavericks
    sha1 "7b0dbd9ef29ae856fee906373e9d53bc383ff062" => :mountain_lion
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
