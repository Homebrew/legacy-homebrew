require 'formula'

class Scapy < Formula
  homepage 'http://www.secdev.org/projects/scapy/'
  
  head 'http://hg.secdev.org/scapy'
  
  url 'http://www.secdev.org/projects/scapy/files/scapy-2.2.0.tar.gz'
  sha1 'ae0a9947a08a01a84abde9db12fed074ac888e47'

  depends_on 'libdnet' => 'with-python'
  depends_on 'libpcap'
  depends_on 'pcap' => :python # From http://pylibpcap.sourceforge.net
 
  # This is satisfied by the 'libdnet' dependency above.
  # depends_on 'dnet' => :python
 
  def install
    system "python setup.py install --prefix=#{prefix}"
  end
end
