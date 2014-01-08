require 'formula'

class Zinc < Formula
  homepage 'https://github.com/typesafehub/zinc'
  url 'http://repo.typesafe.com/typesafe/zinc/com/typesafe/zinc/dist/0.3.0/zinc-0.3.0.tgz'
  sha1 'ccadd9bd08ad7ce6ad3167d1cf0a6ca47eee14a3'

  def install
    rm_f Dir["bin/ng/{linux,win}*"]
    libexec.install Dir['*']
    bin.install_symlink libexec/"bin/zinc"
  end
end
