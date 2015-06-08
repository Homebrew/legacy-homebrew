class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "http://www.libjpeg-turbo.org/"
  url "https://downloads.sourceforge.net/project/libjpeg-turbo/1.4.0/libjpeg-turbo-1.4.0.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/libj/libjpeg-turbo/libjpeg-turbo_1.4.0.orig.tar.gz"
  sha1 "a9ed7a99a6090e0848836c5df8e836f300a098b9"

  bottle do
    cellar :any
    sha1 "847dab53f17c69fc8670407f42d6e6da30e3f527" => :yosemite
    sha1 "d682021ac4745c3e3cfe4a6f1baf6bf07628966a" => :mavericks
    sha1 "f5a667481af812c39caca21ec7842bf678864df3" => :mountain_lion
  end

  depends_on "libtool" => :build
  depends_on "nasm" => :build if MacOS.prefer_64_bit?

  keg_only "libjpeg-turbo is not linked to prevent conflicts with the standard libjpeg."

  def install
    cp Dir["#{Formula["libtool"].opt_share}/libtool/*/config.{guess,sub}"], buildpath
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}", "--with-jpeg8", "--mandir=#{man}"]
    if MacOS.prefer_64_bit?
      # Auto-detect our 64-bit nasm
      args << "NASM=#{Formula["nasm"].bin}/nasm"
    end

    system "./configure", *args
    system "make"
    ENV.j1 # Stops a race condition error: file exists
    system "make", "install"
  end

  test do
    system "#{bin}/jpegtran", "-crop", "1x1",
                              "-transpose", "-perfect",
                              "-outfile", "out.jpg",
                              test_fixtures("test.jpg")
  end
end
