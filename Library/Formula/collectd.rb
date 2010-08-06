require 'formula'

class Collectd <Formula
  url 'http://collectd.org/files/collectd-4.10.1.tar.bz2'
  homepage 'http://collectd.org/'
  md5 '8cd79b4ebdb9dbeb51ba52d3463a06ef'

  def skip_clean? path
    true
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
