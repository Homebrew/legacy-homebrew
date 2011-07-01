require 'formula'

class Tinyproxy < Formula
  url 'https://www.banu.com/pub/tinyproxy/1.6/tinyproxy-1.6.5.tar.gz'
  homepage 'https://www.banu.com/tinyproxy/'
  md5 '2b2862ba33d2939e4572688d442ba415'

  skip_clean 'var/run'

  def install
    inreplace 'doc/tinyproxy.conf' do |s|
      s.gsub! '/var', var
      s.gsub! '/usr/share', share
    end

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
