require 'formula'

class JpegTurbo < Formula
  homepage 'http://www.libjpeg-turbo.org/'
  url 'http://downloads.sourceforge.net/project/libjpeg-turbo/1.2.0/libjpeg-turbo-1.2.0.tar.gz'
  sha1 '4ab00afc9a8d54cd2e7a67aacb9c49e01a8bccac'

  depends_on 'nasm' => :build if MacOS.prefer_64_bit?

  keg_only "libjpeg-turbo is not linked to prevent conflicts with the standard libjpeg."

  def install
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    args << "--host=x86_64-apple-darwin" if MacOS.prefer_64_bit?
    system "./configure", *args
    system 'make'
    ENV.j1 # Stops a race condition error: file exists
    system "make install"
  end

  def test
    mktemp do
      system "#{bin}/jpegtran -crop 500x500+200+500 -transpose -perfect -outfile test.jpg /System/Library/CoreServices/DefaultDesktop.jpg"
      system "/usr/bin/qlmanage", "-p", "test.jpg"
    end
  end
end
