require 'formula'

class JpegTurbo < Formula
  homepage 'http://www.libjpeg-turbo.org/'
  url 'http://downloads.sourceforge.net/project/libjpeg-turbo/1.2.1/libjpeg-turbo-1.2.1.tar.gz'
  sha1 'a4992e102c6d88146709e8e6ce5896d5d0b5a361'

  depends_on 'nasm' => :build if MacOS.prefer_64_bit?

  keg_only "libjpeg-turbo is not linked to prevent conflicts with the standard libjpeg."

  def install
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    if MacOS.prefer_64_bit?
      args << "--host=x86_64-apple-darwin"
      # Auto-detect our 64-bit nasm
      args << "NASM=#{Formula.factory('nasm').bin}/nasm"
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
