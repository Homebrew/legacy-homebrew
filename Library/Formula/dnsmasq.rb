require 'brewkit'

class Dnsmasq <Formula
  @url='http://www.thekelleys.org.uk/dnsmasq/dnsmasq-2.50.tar.gz'
  @homepage='http://www.thekelleys.org.uk/dnsmasq/doc.html'
  @md5='f7b1e17c590e493039537434c57c9de7'

  def install
    ENV.deparallelize
    system "make install PREFIX=#{prefix}"
  end
end
