require 'formula'

class Btpd < Formula
  homepage 'https://github.com/btpd/btpd'
  url 'https://github.com/downloads/btpd/btpd/btpd-0.16.tar.gz'
  sha1 'fb7d396ed5c224dc6e743ac481e4feb4a3cf7b75'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
