require 'formula'

class Libdsk < Formula
  homepage 'http://www.seasip.info/Unix/LibDsk/'
  url 'http://www.seasip.info/Unix/LibDsk/libdsk-1.3.3.tar.gz'
  sha1 '5ec36eb90cc55ba74b68b1529a15c51d60d382fe'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
    (share+name+'doc').install Dir['doc/*.{html,txt,pdf}']
  end
end
