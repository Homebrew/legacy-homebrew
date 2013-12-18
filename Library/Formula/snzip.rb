require 'formula'

class Snzip < Formula
  homepage 'https://github.com/kubo/snzip'
  url 'https://github.com/downloads/kubo/snzip/snzip-0.9.0.tar.gz'
  sha1 '04c02df2cfe80dbe7222dfd6b3e0b0747fdbc024'

  depends_on 'snappy'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/'test.out').write "test"
    system "snzip", "test.out"
    system "snzip", "-d", "test.out.snz"
  end
end
