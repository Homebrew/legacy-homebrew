class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/0.7.81/MediaInfo_CLI_0.7.81_GNU_FromSource.tar.bz2"
  version "0.7.81"
  sha256 "614db812374f3b13400396ae3783384ddf78f62bbf5266c4e2d8b92403d5353c"

  bottle do
    cellar :any
    sha256 "0d0b6d5a2af9c8997eb5267e80aa5a66469c15b7eb01c7744cafa12909def5db" => :el_capitan
    sha256 "1fadeb643d13544ffa84e377b2b72cee236c8389042325ffe090b473aeed3e04" => :yosemite
    sha256 "57dc14039d0e1ffdae320af8a20ce6e2690fc9db5915f023162f034596b08193" => :mavericks
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
