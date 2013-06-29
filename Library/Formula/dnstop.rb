require 'formula'

class Dnstop < Formula
  homepage 'http://dns.measurement-factory.com/tools/dnstop/index.html'
  url 'http://dns.measurement-factory.com/tools/dnstop/src/dnstop-20121017.tar.gz'
  sha1 '836d9bc118df539b80eb349ca45c946323b13366'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.install 'dnstop'
    man8.install 'dnstop.8'
  end

end
