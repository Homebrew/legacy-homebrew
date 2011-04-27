require 'formula'

class Httperf < Formula
  url 'http://httperf.googlecode.com/files/httperf-0.9.0.tar.gz'
  homepage 'http://code.google.com/p/httperf/'
  md5 '2968c36b9ecf3d98fc1f2c1c9c0d9341'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
