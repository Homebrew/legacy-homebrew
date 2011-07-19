require 'formula'

class Libxtract < Formula
  homepage 'http://libxtract.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/libxtract/libxtract/libxtract-0.6.3/libxtract-0.6.3.tar.gz'
  md5 '43cd8403b9227690dd7e8c09acaefc36'

  depends_on 'fftw'

  def options
    [["--universal", "Build a universal binary."]]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
           "--enable-fft", "--prefix=#{prefix}"
    system "make install"
  end
end
