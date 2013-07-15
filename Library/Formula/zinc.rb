require 'formula'

class Zinc < Formula
  homepage 'https://github.com/typesafehub/zinc'
  url 'http://repo.typesafe.com/typesafe/zinc/com/typesafe/zinc/dist/0.2.0/zinc-0.2.0.tgz'
  sha1 '1161817f71a9dc1326a58854b40bdc80d19f8e4d'

  def install
    rm_f Dir["bin/ng/{linux,win}*"]
    libexec.install Dir['*']
    bin.install_symlink libexec/"bin/zinc"
  end
end
