require 'formula'

class Stress < Formula
  url 'http://weather.ou.edu/~apw/projects/stress/stress-1.0.4.tar.gz'
  homepage 'http://weather.ou.edu/~apw/projects/stress/'
  md5 'a607afa695a511765b40993a64c6e2f4'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
