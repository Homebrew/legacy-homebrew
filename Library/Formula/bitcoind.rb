require 'formula'

class Bitcoind < Formula
  homepage 'http://bitcoin.org'

  # No released version until next one that has the homebrew config info. Coming soon.
  # url 'https://github.com/bitcoin/bitcoin/archive/master.zip'
  # sha1 'd32c281f5eec137843c7256250b6d8aba8656e05'
  head 'git://github.com/bitcoin/bitcoin.git'

  depends_on 'boost'
  depends_on 'openssl'
  depends_on 'miniupnpc'
  depends_on 'berkeley-db4'

  def install
    system 'patch -p1 < contrib/homebrew/makefile.osx.patch'
    system 'cd ./src && make -f makefile.osx'
    bin.install 'src/bitcoind'
  end
end