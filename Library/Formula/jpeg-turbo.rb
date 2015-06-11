class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "http://www.libjpeg-turbo.org/"
  url "https://downloads.sourceforge.net/project/libjpeg-turbo/1.4.1/libjpeg-turbo-1.4.1.tar.gz"
  sha256 "4bf5bad4ce85625bffbbd9912211e06790e00fb982b77724af7211034efafb08"

  bottle do
    cellar :any
    sha256 "1938c9a93f0de685fd2b2c48f9d7f4d6ccd214260e76b177dc5aa5c5231f8876" => :yosemite
    sha256 "dbb0b0a91c703b860746cf4cd08a2b88e2946cf4b086ad86a6c81ff603ce81c0" => :mavericks
    sha256 "d0aee820193caf7d5c365869ce932ccfbe2c6dc76c6a81e0dc73b8f5f08ba5c0" => :mountain_lion
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
