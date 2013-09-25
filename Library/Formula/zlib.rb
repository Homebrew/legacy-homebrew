require 'formula'

class Zlib < Formula
  homepage 'http://www.zlib.net/'
  url 'http://zlib.net/zlib-1.2.8.tar.gz'
  sha1 'a4d316c404ff54ca545ea71a27af7dbc29817088'

  def patches
    {:p1 => "https://gist.github.com/michelangelo/6706342/raw/6fa96feaed48ff76f55fa51a99177fce033a2318/configure.patch"}
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
