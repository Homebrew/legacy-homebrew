class Mediaconch < Formula
  desc "Conformance checker and technical metadata reporter"
  homepage "https://mediaarea.net/MediaConch"
  url "https://mediaarea.net/download/binary/mediaconch/16.02/MediaConch_CLI_16.02_GNU_FromSource.tar.bz2"
  version "16.02"
  sha256 "62820ef7fe162fd5b50f6159e339358e6267f6078dbedb88b97493bb25f8a270"

  bottle do
    cellar :any
    sha256 "5d10a751a754e308976442c54d1f2f42ec92dc340c5ae5be2e5491149bd89874" => :el_capitan
    sha256 "53a1b5cbb623cfcbb7ee08a94cbc8a37ae945098a9506a2a363a666bc21d00b9" => :yosemite
    sha256 "92b0adad7e37a08af408185d6b3305cf7fe9cc477e75c38bbdebd6f37a7880df" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libevent"
  depends_on "sqlite"
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
              "--prefix=#{prefix}",
              # mediaconch installs libs/headers at the same paths as mediainfo
              "--libdir=#{lib}/mediaconch",
              "--includedir=#{include}/mediaconch"]
      system "./configure", *args
      system "make", "install"
    end

    cd "MediaConch/Project/GNU/CLI" do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    pipe_output("#{bin}/mediaconch", test_fixtures("test.mp3"))
  end
end
