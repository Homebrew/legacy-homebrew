require 'formula'

class Gqlplus < Formula
  url 'http://downloads.sourceforge.net/project/gqlplus/gqlplus/1.12/gqlplus-1.12.tar.gz'
  homepage 'http://gqlplus.sourceforge.net/'
  md5 'a6ff4af76f10fd11a17227e5f287b355'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    bin.install "gqlplus"
  end
end
