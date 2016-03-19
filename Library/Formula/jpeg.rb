class Jpeg < Formula
  desc "JPEG image manipulation library"
  homepage "http://www.ijg.org"
  url "http://www.ijg.org/files/jpegsrc.v9b.tar.gz"
  sha256 "240fd398da741669bf3c90366f58452ea59041cacc741a489b99f2f6a0bad052"

  option :universal

  stable do
    patch :p0 do
      url "ftp://ftp.netbsd.org/pub/pkgsrc/current/pkgsrc/graphics/jpeg/patches/patch-jmorecfg.h"
      sha256 "9b26396b4124fda61fe70dd7a672e56300d8178612ef464e33dac9b0601c2ad3"
    end

    def install
      ENV.universal_binary if build.universal?
      system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/djpeg", test_fixtures("test.jpg")
  end
end
