require 'formula'

class JpegTurbo < Formula
  homepage 'http://www.libjpeg-turbo.org/'
  url 'http://downloads.sourceforge.net/project/libjpeg-turbo/1.3.0/libjpeg-turbo-1.3.0.tar.gz'
  sha1 '1792c964b35604cebd3a8846f1ca6de5976e9c28'

  keg_only "libjpeg-turbo is not linked to prevent conflicts with the standard libjpeg."

  head do
    url 'svn://svn.code.sf.net/p/libjpeg-turbo/code/trunk'

    depends_on :automake
    depends_on :libtool
  end
  depends_on 'nasm' => :build if MacOS.prefer_64_bit?

  option :universal

  def install
    ENV.universal_binary if build.universal?
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}", "--with-jpeg8"]
    if MacOS.prefer_64_bit?
      args << "--host=x86_64-apple-darwin"
      # Auto-detect our 64-bit nasm
      args << "NASM=#{Formula.factory('nasm').bin}/nasm"
    end

    system "autoreconf", "-fvi" if build.head?
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
