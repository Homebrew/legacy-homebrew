class Mediaconch < Formula
  desc "Conformance checker and technical metadata reporter"
  homepage "https://mediaarea.net/MediaConch"
  url "https://mediaarea.net/download/binary/mediaconch/15.12/MediaConch_CLI_15.12hotfix1_GNU_FromSource.tar.bz2"
  version "15.12"
  sha256 "4899d43c097c552b2f970da6362407f002c61f93b11e8be3cf79b29c4733fd06"
  revision 1

  bottle do
    cellar :any
    sha256 "f226b697b1f1bfd4331f726668e1636f95c5f56bbd50ac134a0982e1aa222b3a" => :el_capitan
    sha256 "bee2dc3b0e7cb39c94d805f794b1b088cbb90671021489581c537bad5c2848f0" => :yosemite
    sha256 "0dd10e2b16a58dc330b3b5b6d0fbe74559f52224bce2be28414458f26d7d6ca0" => :mavericks
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
