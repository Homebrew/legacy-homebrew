require 'formula'

class VpncScript < Formula
  url 'http://git.infradead.org/users/dwmw2/vpnc-scripts.git/blob_plain/HEAD:/vpnc-script'
  md5 '7a51184f883bba826615e85853e6d30a'

end

class Openconnect < Formula
  url 'ftp://ftp.infradead.org/pub/openconnect/openconnect-4.03.tar.gz'
  homepage 'http://www.infradead.org/openconnect.html'
  md5 'c9281aaaad2a28429fe73e71f92a2a24'

  depends_on 'gettext' => :build

  def install
    VpncScript.new.brew { etc.install Dir['*'] }
    chmod 0755, "#{etc}/vpnc-script"

    args = ["--prefix=#{prefix}",
            "--sbindir=#{bin}",
            "--mandir=#{man}",
            "--with-vpnc-script=#{etc}/vpnc-script"]

    system "./configure", *args
    system "make install"
  end
end
