class Mp3unicode < Formula
  desc "Command-line utility to convert mp3 tags between different encodings"
  homepage "http://mp3unicode.sourceforge.net/"
  url "https://github.com/downloads/alonbl/mp3unicode/mp3unicode-1.2.1.tar.bz2"
  sha256 "375b432ce784407e74fceb055d115bf83b1bd04a83b95256171e1a36e00cfe07"
  head "https://github.com/alonbl/mp3unicode.git"

  depends_on "taglib"

  def install
    ENV.append "PKG_CONFIG", "true"
    ENV.append "TAGLIB_CFLAGS", "-I#{Formula["taglib"].opt_include}/taglib"
    ENV.append "TAGLIB_LIBS", "-L#{Formula["taglib"].opt_lib} -ltag"
    ENV.append "ICONV_LIBS", "-liconv"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/mp3unicode", "-s", "ASCII", "-w", test_fixtures("test.mp3")
  end
end
