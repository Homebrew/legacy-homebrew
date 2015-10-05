class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/0.7.78/MediaInfo_CLI_0.7.78_GNU_FromSource.tar.bz2"
  version "0.7.78"
  sha256 "ee52cb774bbb6e14b182e71a1be84700ba540b5153e14857a3d7115fb4c6cd78"

  bottle do
    cellar :any_skip_relocation
    sha256 "088151f1e27a53142b34b7779da8b4c1e469ab68f50993ebde46dab8215f450e" => :el_capitan
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
