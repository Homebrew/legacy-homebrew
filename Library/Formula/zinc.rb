require 'formula'

class Zinc < Formula
  homepage 'https://github.com/typesafehub/zinc'
  url 'http://downloads.typesafe.com/zinc/0.3.5/zinc-0.3.5.tgz'
  sha1 '1ae45236fdf0ad91e739889bffb7829d9308cdea'

  def install
    rm_f Dir["bin/ng/{linux,win}*"]
    libexec.install Dir['*']
    bin.install_symlink libexec/"bin/zinc"
  end
end
