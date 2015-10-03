class Lpc21isp < Formula
  desc "In-circuit programming (ISP) tool for several NXP microcontrollers"
  homepage "http://lpc21isp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/lpc21isp/lpc21isp/1.97/lpc21isp_197.tar.gz"
  sha256 "9f7d80382e4b70bfa4200233466f29f73a36fea7dc604e32f05b9aa69ef591dc"
  version "1.97"

  def install
    system "make"
    bin.install ["lpc21isp"]
  end
end
