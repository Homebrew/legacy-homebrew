require 'formula'

class Tor <Formula
  url 'https://www.torproject.org/dist/tor-0.2.1.25.tar.gz'
  homepage 'https://www.torproject.org/'
  md5 'f58540b3c5835ac4f5de1b02bbddc703'
  
  depends_on 'libevent'
  
  def patches
    {:p0 => 'http://gist.github.com/raw/344132/d27d1cd3042d7c58120688d79ed25a2fc959a2de/config.guess-x86_64patch.diff' }
  end
  
  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
