class Mediaconch < Formula
  desc "Conformance checker and technical metadata reporter"
  homepage "https://mediaarea.net/MediaConch"
  url "https://mediaarea.net/download/binary/mediaconch/16.01/MediaConch_CLI_16.01_GNU_FromSource.tar.bz2"
  version "16.01"
  sha256 "b97d2a2137917dac1db6aca45b95375e1d0d2c742d2a170ebd27204e4b1b2ddf"

  bottle do
    cellar :any
    sha256 "d044ac64e368aaf53cf0cc41fff134c3ad63bff3c5ffd4e3b1afbd1814ef34f4" => :el_capitan
    sha256 "dea0829d2758aa76d2f091e93df8c6df46989e12b9e5d3678ec987955048edc3" => :yosemite
    sha256 "802b5bd4932cdcaaef9d2cf832aee36433efab9d1fb6540055f5104398e5744e" => :mavericks
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
