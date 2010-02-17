require 'formula'

class Dnsmasq <Formula
  @url='http://www.thekelleys.org.uk/dnsmasq/dnsmasq-2.52.tar.gz'
  @homepage='http://www.thekelleys.org.uk/dnsmasq/doc.html'
  @md5='1bb32fffdb4f977ead607802b5d701d0'

  def install
    ENV.deparallelize
    system "make install PREFIX=#{prefix}"
  end
end
