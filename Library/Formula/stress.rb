require 'formula'

class Stress < Formula
  url 'http://weather.ou.edu/~apw/projects/stress/stress-1.0.4.tar.gz'
  homepage 'http://weather.ou.edu/~apw/projects/stress/'
  sha1 '7ccb6d76d27ddd54461a21411f2bc8491ba65168'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
