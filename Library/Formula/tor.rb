require 'formula'

class Tor <Formula
  url 'https://www.torproject.org/dist/tor-0.2.1.22.tar.gz'
  homepage 'https://www.torproject.org/'
  md5 '583501a989ed0c39e209b604c3671ecd'
  
  depends_on 'libevent'
  
  def patches
    {:p0 => 'http://gist.github.com/raw/268813/bba4403191b4aa382eff0671afb4ed7f97748c6f/config.guess-x86_64fix.diff' }
  end
  
  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
