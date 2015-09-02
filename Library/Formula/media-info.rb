class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/0.7.77/MediaInfo_CLI_0.7.77_GNU_FromSource.tar.bz2"
  version "0.7.77"
  sha256 "b96cbb358f6ae7d18f2a409a8945244fa053530736d00a8fb6d2cc0e7218a1f3"

  bottle do
    cellar :any
    sha256 "79c3809bed4864fd00d9b238c57d8d2f044ea8a3b0ce1ba4e1eff774b1fd646d" => :yosemite
    sha256 "2b97ead07da095970f049297e324949178fd4f62a187cba53e497d0546a8fa99" => :mavericks
    sha256 "ebaf410673dc4380e4944736bbccaeb0e69062dd850e6e50a8ab849f418de7a2" => :mountain_lion
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
