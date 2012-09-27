require 'formula'

class Dnstop < Formula
  homepage 'http://dns.measurement-factory.com/tools/dnstop/index.html'
  url 'http://dns.measurement-factory.com/tools/dnstop/src/dnstop-20120611.tar.gz'
  sha1 'a5fb7e9d307488f2f6aaaa0291b9c7c187f68fd9'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.install 'dnstop'
    man8.install 'dnstop.8'
  end

end
