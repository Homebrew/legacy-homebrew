require 'formula'

class Tor <Formula
  url 'https://www.torproject.org/dist/tor-0.2.1.21.tar.gz'
  homepage 'https://www.torproject.org/'
  md5 '54f7a801d824cd9c13ce672d483926d6'
  
  depends_on 'libevent'
  
  def patches
    {:p0 => 'http://gist.github.com/raw/268813/bba4403191b4aa382eff0671afb4ed7f97748c6f/config.guess-x86_64fix.diff' }
  end
  
  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
