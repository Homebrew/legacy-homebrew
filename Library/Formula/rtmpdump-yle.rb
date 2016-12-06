require 'formula'

class RtmpdumpYle <Formula
  url 'http://users.tkk.fi/~aajanki/rtmpdump-yle/rtmpdump-yle-1.3.1.tar.gz'
  homepage 'http://users.tkk.fi/~aajanki/rtmpdump-yle/index.html'
  md5 '58628917a93eec684d2f67ba82d095aa'

  def install
    system "./configure-json-c"
    system "make SYS=darwin"
    system "make install SYS=darwin"
  end
end
