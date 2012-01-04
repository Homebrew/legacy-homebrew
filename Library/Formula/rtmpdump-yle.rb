require 'formula'

class RtmpdumpYle < Formula
  url 'http://users.tkk.fi/~aajanki/rtmpdump-yle/rtmpdump-yle-1.4.6.tar.gz'
  homepage 'http://users.tkk.fi/~aajanki/rtmpdump-yle/'
  md5 '41ba45e6f6482f55eb5e4c05f77e7eeb'

  depends_on 'json-c'

  def install
    system "make SYS=darwin INC=-I/usr/local/include/json"
    system "make install SYS=darwin prefix=#{prefix}"
  end

  def test
    system("#{bin}/rtmpdump-yle --help")
    ohai 'rtmpdump-yle is installed'
    
    unless File.exists?("#{bin}/yle-dl")
      onoe 'yle-dl was not found'
    else
      ohai 'yle-dl is found'
    end
  end
  
end
