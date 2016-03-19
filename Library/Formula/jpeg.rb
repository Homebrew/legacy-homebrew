class Jpeg < Formula
  desc "JPEG image manipulation library"
  homepage "http://www.ijg.org"
  url "http://www.ijg.org/files/jpegsrc.v9b.tar.gz"
  version "9b"
  sha256 "240fd398da741669bf3c90366f58452ea59041cacc741a489b99f2f6a0bad052"

  option :universal

  def install
    ENV.universal_binary if build.universal?
     system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/djpeg", test_fixtures("test.jpg")
  end
end
