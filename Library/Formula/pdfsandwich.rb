class Pdfsandwich < Formula
  desc "Tool to make \"sandwich\" OCR pdf files"
  homepage "http://www.tobias-elze.de/pdfsandwich/"
  url "https://downloads.sourceforge.net/project/pdfsandwich/pdfsandwich%200.1.4/pdfsandwich-0.1.4.tar.bz2"
  sha256 "8b82f3ae08000c5cae1ff5a0f6537b0b563befef928e5198255b743a46714af3"

  depends_on "tesseract"
  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on "ocaml"
  depends_on "unpaper"
  depends_on "gawk"

  def install
    bin.mkpath
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make"
    system "make install"
  end

  test do
    system "pdfsandwich"
  end
end
