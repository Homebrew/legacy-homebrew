require 'formula'

class Zinc < Formula
  desc "Stand-alone version of sbt's Scala incremental compiler"
  homepage 'https://github.com/typesafehub/zinc'
  url 'http://downloads.typesafe.com/zinc/0.3.7/zinc-0.3.7.tgz'
  sha1 '442e3fde66f58c642efb7fa1355166318f4ac5cd'

  def install
    rm_f Dir["bin/ng/{linux,win}*"]
    libexec.install Dir['*']
    bin.install_symlink libexec/"bin/zinc"
  end
end
