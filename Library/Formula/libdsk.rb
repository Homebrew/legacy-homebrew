require 'formula'

class Libdsk < Formula
  homepage 'http://www.seasip.info/Unix/LibDsk/'
  url 'http://www.seasip.info/Unix/LibDsk/libdsk-1.3.8.tar.gz'
  sha1 'eac675db4e16f35c86ba2d2f865c8e58a99156a7'

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
