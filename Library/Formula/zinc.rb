class Zinc < Formula
  desc "Stand-alone version of sbt's Scala incremental compiler"
  homepage "https://github.com/typesafehub/zinc"
  url "https://downloads.typesafe.com/zinc/0.3.7/zinc-0.3.7.tgz"
  sha256 "8775465c624bfb2180cb03734e6ad682849663b3a70fa73bb962af496df89a3d"

  bottle :unneeded

  def install
    rm_f Dir["bin/ng/{linux,win}*"]
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/zinc"
  end
end
