class Mp3splt < Formula
  desc "Command-line interface to split MP3 and Ogg Vorbis files"
  homepage "http://mp3splt.sourceforge.net"
  url "https://downloads.sourceforge.net/project/mp3splt/mp3splt/2.6.2/mp3splt-2.6.2.tar.gz"
  sha1 "f61094a1348cffb704ef021e59c1d26c4dc652ab"

  bottle do
    sha1 "00b4f15259c7e26e86dac674ef4169f8df2108e8" => :yosemite
    sha1 "95a482d23df7573de4672fde06dae68939a968a2" => :mavericks
    sha1 "30c65da5f3df5bd4b28420894bd9464cc857d2c9" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libmp3splt"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/mp3splt", "-t", "0.1", test_fixtures("test.mp3")
  end
end
