class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/0.7.77/MediaInfo_CLI_0.7.77_GNU_FromSource.tar.bz2"
  version "0.7.77"
  sha256 "b96cbb358f6ae7d18f2a409a8945244fa053530736d00a8fb6d2cc0e7218a1f3"

  bottle do
    cellar :any
    revision 1
    sha256 "d19d18d862ff218fb8b21f0d1b7aad9187ca516f0afa155cf384db46f22c4ddf" => :el_capitan
    sha256 "402a0258b26f7d9072170c1e705357d9fb1c2d77e69c02c9919608ba2fa0be5a" => :yosemite
    sha256 "cf43853b47f78e6e3c2d0de2a52fbcc7b8c552974e6e57b38664f6a4641bc0f3" => :mavericks
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
              "--enable-static",
              "--enable-shared",
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
