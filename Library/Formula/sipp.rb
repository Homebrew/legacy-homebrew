require 'formula'

class Sipp < Formula
  homepage 'http://sipp.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/sipp/sipp/3.4/sipp-3.3.990.tar.gz'
  sha1 'b2637cb72556595253bbdd4a68cc974c9ac1d92e'

  option 'pcap',     'Build with PCAP support'
  option 'openssl',  'Build with OpenSSL support'

  depends_on 'openssl'   if build.include? 'openssl'

  def install
    args = []

    args << "--with-pcap" if build.include? 'pcap'
    args << "--with-openssl" if build.include? 'openssl'

    system "./configure", *args
    system "make", "DESTDIR=#{prefix}"
    bin.install "sipp"
  end
end
