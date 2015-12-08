class Mediaconch < Formula
  desc "Conformance checker and technical metadata reporter"
  homepage "https://mediaarea.net/MediaConch"
  url "https://mediaarea.net/download/binary/mediaconch/15.11/MediaConch_CLI_15.11_GNU_FromSource.tar.bz2"
  version "15.11"
  sha256 "06f76ac63a41eb5b7e2c31fd16e450a2d7ae93db832710497d140c1b2c47bf82"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "6952797738c558cc457ce26155de8c697e542967eae0a705df92769574e96848" => :el_capitan
    sha256 "b7bc97e760479f97f35c54ff9bef9d0f08ebfb7286c3bb7684d99c26a182d58e" => :yosemite
    sha256 "ec3441854b7c60d59a1c6df057da0ba6853c3e1bf320199f6ab5414aa96c32c6" => :mavericks
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
