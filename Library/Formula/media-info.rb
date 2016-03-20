class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/0.7.83/MediaInfo_CLI_0.7.83_GNU_FromSource.tar.bz2"
  version "0.7.83"
  sha256 "c39681085f3030dca042cbff8d19b6625df1af295eb0a0dc189ec67b1963bd7d"

  bottle do
    cellar :any
    sha256 "d64258cf7d118e4877940d77da5491ead5037c9459c26b918b9e336e7b459dc5" => :el_capitan
    sha256 "34822a75a7390c118161e1d2e0e57dc16bd160fcb6fe401791103a1f060455bf" => :yosemite
    sha256 "68eab7eb67939e945a76f4f7ce807cbcbf5f3a93eba89278ea2e8ea32fb6cf8a" => :mavericks
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
