class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "http://www.libjpeg-turbo.org/"
  url "https://downloads.sourceforge.net/project/libjpeg-turbo/1.4.1/libjpeg-turbo-1.4.1.tar.gz"
  sha256 "4bf5bad4ce85625bffbbd9912211e06790e00fb982b77724af7211034efafb08"

  bottle do
    cellar :any
    revision 1
    sha256 "218868e1fb9626b17f31b1e3f5141b7c41b31b5a0ff2259b2945ac1a0ed9433c" => :el_capitan
    sha256 "cabd0a3e26c9d80b38ca1128867722824a89cc6ea7275038a5f08a36256d57a7" => :yosemite
    sha256 "3f952c0dc994d39dec8f0bffa7ad4092d235154c4044fc8ebf0afcc14a624535" => :mavericks
    sha256 "1bc6d039b8ec75bb9c740b054e0a1f397c265a7c89fad3695f90dc467cd484dd" => :mountain_lion
  end

  option "without-test", "Skip build-time checks (Not Recommended)"

  depends_on "libtool" => :build

  keg_only "libjpeg-turbo is not linked to prevent conflicts with the standard libjpeg."

  # https://github.com/Homebrew/homebrew/issues/41023
  # http://sourceforge.net/p/libjpeg-turbo/mailman/message/34219546/
  # Should be safe to remove once nasm 2.11.09 lands - Check first.
  resource "nasm" do
    url "http://www.nasm.us/pub/nasm/releasebuilds/2.11.06/nasm-2.11.06.tar.xz"
    sha256 "90f60d95a15b8a54bf34d87b9be53da89ee3d6213ea739fb2305846f4585868a"
  end

  def install
    cp Dir["#{Formula["libtool"].opt_share}/libtool/*/config.{guess,sub}"], buildpath
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}", "--with-jpeg8", "--mandir=#{man}"]

    if MacOS.prefer_64_bit?
      resource("nasm").stage do
        system "./configure", "--prefix=#{buildpath}/nasm"
        system "make", "install"
      end

      ENV.prepend_path "PATH", buildpath/"nasm/bin"
      args << "NASM=#{buildpath}/nasm/bin/nasm"
    end

    system "./configure", *args
    system "make"
    system "make", "test" if build.with? "test"
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
