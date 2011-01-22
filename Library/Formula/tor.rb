require 'formula'

class Tor <Formula
  url 'https://www.torproject.org/dist/tor-0.2.1.29.tar.gz'
  homepage 'https://www.torproject.org/'
  md5 '1cd4feea84f2b066717b500d090bcf65'

  depends_on 'libevent'

  def patches
    {:p0 => 'https://gist.github.com/raw/344132/d27d1cd3042d7c58120688d79ed25a2fc959a2de/config.guess-x86_64patch.diff' }
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
