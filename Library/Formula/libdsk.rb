require 'formula'

class Libdsk < Formula
  homepage 'http://www.seasip.info/Unix/LibDsk/'
  url 'http://www.seasip.info/Unix/LibDsk/libdsk-1.3.3.tar.gz'
  sha1 '5ec36eb90cc55ba74b68b1529a15c51d60d382fe'

  bottle do
    sha1 "bb7e7f2159b8f17ddcd6b25f0256e174549e3790" => :mavericks
    sha1 "c6cdaf38dc5b4ded63ccf782c29fd2090584ff31" => :mountain_lion
    sha1 "534f16fc632118777ad39db7acfcb427fc3beb2a" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
    (share+name+'doc').install Dir['doc/*.{html,txt,pdf}']
  end
end
