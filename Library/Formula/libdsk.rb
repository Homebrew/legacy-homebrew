require 'formula'

class Libdsk < Formula
  url 'http://www.seasip.info/Unix/LibDsk/libdsk-1.3.3.tar.gz'
  homepage 'http://www.seasip.info/Unix/LibDsk/'
  md5 '2cce41b4b1325d697183e34afcae2a9c'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
    (share+name+'doc').install Dir['doc/*.{html,txt,pdf}']
  end
end
