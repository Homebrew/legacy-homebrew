require 'formula'

class Bitcoind < Formula
  homepage 'http://bitcoin.org/'
  url 'https://github.com/bitcoin/bitcoin/archive/v0.7.2.tar.gz'
  sha1 '6afb648f273a52934a65d8a127a08dccdb74db48'
  head 'https://github.com/bitcoin/bitcoin.git'

  depends_on 'boost'
  depends_on 'berkeley-db4'
  depends_on 'miniupnpc' if build.include? 'with-upnp'

  option 'with-upnp', 'Compile with UPnP support'
  option 'without-ipv6', 'Compile without IPv6 support'

  def install
    cd 'src' do
        system "make", "-f", "makefile.osx",
                       "DEPSDIR=#{HOMEBREW_PREFIX}",
                       "USE_UPNP=#{(build.include? 'with-upnp') ? '1' : '-'}",
                       "USE_IPV6=#{(build.include? 'without-ipv6') ? '-' : '1'}"

        bin.install 'bitcoind'
    end
  end

  def caveats; <<-EOS.undent
    You will need to setup your bitcoin.conf:
        echo "rpcuser=user" >> ~/Library/Application Support/Bitcoin/bitcoin.conf
        echo "rpcpassword=password" >> ~/Library/Application Support/Bitcoin/bitcoin.conf
    EOS
  end
end
