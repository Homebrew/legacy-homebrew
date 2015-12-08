class Mediaconch < Formula
  desc "Conformance checker and technical metadata reporter"
  homepage "https://mediaarea.net/MediaConch"
  url "https://mediaarea.net/download/binary/mediaconch/15.11/MediaConch_CLI_15.11_GNU_FromSource.tar.bz2"
  version "15.11"
  sha256 "06f76ac63a41eb5b7e2c31fd16e450a2d7ae93db832710497d140c1b2c47bf82"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "54f45f88f933e2d9d66e11d2eaa33ce5606fd20ebd07c3c8622c74f7793af3ef" => :el_capitan
    sha256 "0e0ea9b251f1cad8e5fc7358fa26c9a50a752407fc556cd7b1ee8bb303623ad1" => :yosemite
    sha256 "9da30167b4741cc6fba1030a4ba0dac1b78ac5dd59f6cd54b936967616907018" => :mavericks
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
