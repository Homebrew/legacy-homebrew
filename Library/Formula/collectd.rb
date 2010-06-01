require 'formula'

class Collectd <Formula
  url 'http://collectd.org/files/collectd-4.10.0.tar.bz2'
  homepage 'http://collectd.org/'
  md5 '2f671d267bf6cb1a9d385107ba7b734d'

  def skip_clean? path
    true
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
