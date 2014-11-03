require 'formula'

class Libdsk < Formula
  homepage 'http://www.seasip.info/Unix/LibDsk/'
  url 'http://www.seasip.info/Unix/LibDsk/libdsk-1.3.3.tar.gz'
  sha1 '5ec36eb90cc55ba74b68b1529a15c51d60d382fe'

  bottle do
    revision 1
    sha1 "f7dbafebd6c36a32d11dacd3123e2db16cf0f182" => :yosemite
    sha1 "d4176d3b7aadad58cf4d0ccd92236dee327bab2f" => :mavericks
    sha1 "b89b0804e8f7d69e8b4a7e95886c54e302fae762" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
    (share+name+'doc').install Dir['doc/*.{html,txt,pdf}']
  end
end
