require 'formula'

class Zinc < Formula
  homepage 'https://github.com/typesafehub/zinc'
  url 'http://repo.typesafe.com/typesafe/zinc/com/typesafe/zinc/dist/0.2.5/zinc-0.2.5.tgz'
  sha1 '2f89bf2b5b77f2353750e1c5fa2a6d0c506c95b3'

  def install
    rm_f Dir["bin/ng/{linux,win}*"]
    libexec.install Dir['*']
    bin.install_symlink libexec/"bin/zinc"
  end
end
