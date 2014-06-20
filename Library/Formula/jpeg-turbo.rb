require 'formula'

class JpegTurbo < Formula
  homepage 'http://www.libjpeg-turbo.org/'
  url 'https://downloads.sourceforge.net/project/libjpeg-turbo/1.3.1/libjpeg-turbo-1.3.1.tar.gz'
  sha1 '5fa19252e5ca992cfa40446a0210ceff55fbe468'

  depends_on "libtool" => :build
  depends_on 'nasm' => :build if MacOS.prefer_64_bit?

  keg_only "libjpeg-turbo is not linked to prevent conflicts with the standard libjpeg."

  def install
    cp Dir["#{Formula["libtool"].opt_share}/libtool/config/config.*"], buildpath
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}", "--with-jpeg8", "--mandir=#{man}"]
    if MacOS.prefer_64_bit?
      # Auto-detect our 64-bit nasm
      args << "NASM=#{Formula["nasm"].bin}/nasm"
    end

    system "./configure", *args
    system 'make'
    ENV.j1 # Stops a race condition error: file exists
    system "make install"
  end

  test do
    system "#{bin}/jpegtran", "-crop", "500x500+200+500",
                              "-transpose", "-perfect",
                              "-outfile", "test.jpg",
                              "/System/Library/CoreServices/DefaultDesktop.jpg"
  end
end
