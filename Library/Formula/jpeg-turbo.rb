require 'formula'

class JpegTurbo < Formula
  homepage 'http://www.libjpeg-turbo.org/'
  url 'http://downloads.sourceforge.net/project/libjpeg-turbo/1.2.0/libjpeg-turbo-1.2.0.tar.gz'
  md5 '5329fa80953938cb4f097afae55059e2'

  if MacOS.prefer_64_bit?
    depends_on 'nasm' => :build
  end

  keg_only "libjpeg-turbo is not linked to prevent conflicts with the standard libjpeg."

  def install
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    args << "--host=x86_64-apple-darwin" if MacOS.prefer_64_bit?
    system "./configure", *args
    system "make install"
  end

  def test
    mktemp do
      system "#{bin}/jpegtran -crop 500x500+200+500 -transpose -perfect -outfile test.jpg /System/Library/CoreServices/DefaultDesktop.jpg"
    end
  end
end
