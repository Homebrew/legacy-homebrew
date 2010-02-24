require 'formula'

class Collectd <Formula
  url 'http://collectd.org/files/collectd-4.9.1.tar.bz2'
  homepage 'http://collectd.org/'
  md5 '5753496651c8c84afaea1fe290876bfc'
  
  def skip_clean? path
    true
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
