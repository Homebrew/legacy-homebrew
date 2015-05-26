require "formula"

class MediaInfo < Formula
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/0.7.74/MediaInfo_CLI_0.7.74_GNU_FromSource.tar.bz2"
  version "0.7.74"
  sha1 "89cf4745e3d9725bf109976a933f36af2a3aa36a"

  bottle do
    cellar :any
    sha256 "ef9b87816abec7cb29ff681b8ffd925589cd1866c843c194b8f8494f23a5b89e" => :yosemite
    sha256 "0f4f4bc38ad87c79e00df107cd8517b9a673efb4b9b0aee210ef19f8877f2081" => :mavericks
    sha256 "49cf01807ee6582926eceaf5507876d4d01d42a6f84a109d69f8ddbef171dc62" => :mountain_lion
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
