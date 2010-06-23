require 'formula'

class Dnsmasq <Formula
  @url='http://www.thekelleys.org.uk/dnsmasq/dnsmasq-2.55.tar.gz'
  @homepage='http://www.thekelleys.org.uk/dnsmasq/doc.html'
  @md5='b093d7c6bc7f97ae6fd35d048529232a'

  def install
    ENV.deparallelize
    system "make install PREFIX=#{prefix}"
  end
end
