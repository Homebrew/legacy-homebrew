class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/0.7.76/MediaInfo_CLI_0.7.76_GNU_FromSource.tar.bz2"
  version "0.7.76"
  sha256 "6865dbd2af34fa81005d76769389724ef2b3f2c1e318a7a909d12751944c0db0"

  bottle do
    cellar :any
    sha256 "32b3fe3149db05dbaa3244b29657d9362c66cebfd69c1365288b00b1b46726ad" => :yosemite
    sha256 "fd79f9dea0727de74945d01125d5a24a5c6cb0b125bbc5972fe284a008eb583c" => :mavericks
    sha256 "5567c0741d3ceb1faa8da7ea21e982136f919e388d30ba631f24167ab626c921" => :mountain_lion
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
      system "make", "install"
    end

    cd "MediaInfo/Project/GNU/CLI" do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    pipe_output("#{bin}/mediainfo", test_fixtures("test.mp3"))
  end
end
