require 'formula'

class Apachebench < Formula
  url 'http://fossies.org/unix/www/ApacheBench-0.72.tar.gz'
  homepage 'http://httpd.apache.org/docs/2.0/programs/ab.html'
  md5 '7bc0d8dcb8ac4d7fb150148aaadac51c'

  def install
    system "perl Makefile.PL PREFIX=#{prefix}"
    system "make"
    system "make test"
    system "make install"
  end
end
