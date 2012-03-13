require 'formula'

class Dnstop < Formula
  url 'http://dns.measurement-factory.com/tools/dnstop/src/dnstop-20110502.tar.gz'
  homepage 'http://dns.measurement-factory.com/tools/dnstop/index.html'
  md5 '28cb54f3780b27e15df8924235e4e37b'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.install 'dnstop'
    man8.install 'dnstop.8'
  end

end
