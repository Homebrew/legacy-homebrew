require 'formula'

class JpegTurbo < Formula
  homepage 'http://www.libjpeg-turbo.org/'
  url 'http://downloads.sourceforge.net/project/libjpeg-turbo/1.2.0/libjpeg-turbo-1.2.0.tar.gz'
  md5 '5329fa80953938cb4f097afae55059e2'

  if MacOS.prefer_64_bit?
    if MacOS.xcode_version.to_f >= 4.3
      depends_on 'automake' => :build
      depends_on 'libtool' => :build
    end
    depends_on 'nasm' => :build
  end

  keg_only "libjpeg-turbo is not linked to prevent conflicts with the standard libjpeg."

  def install
    # we need to reconfigure for 64bit compatibility
    if MacOS.prefer_64_bit?
      ENV['LIBTOOLIZE'] = 'glibtoolize'
      system "autoreconf", "-ivf"
    end
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    mktemp do
      system "#{bin}/jpegtran -crop 500x500+200+500 -transpose -perfect -outfile test.jpg /System/Library/CoreServices/DefaultDesktop.jpg"
    end
  end
end
