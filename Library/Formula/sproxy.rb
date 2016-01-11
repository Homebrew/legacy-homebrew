class Sproxy < Formula
  desc "HTTP proxy server collecting URLs in a 'siege-friendly' manner"
  homepage "https://www.joedog.org/sproxy-home/"
  url "http://download.joedog.org/sproxy/sproxy-1.02.tar.gz"
  sha256 "29b84ba66112382c948dc8c498a441e5e6d07d2cd5ed3077e388da3525526b72"

  bottle do
    revision 1
    sha256 "d67b0980fcf79176396ee6e144ca1ba5d32a81663f8265364c280c2dc9aa99e7" => :yosemite
    sha256 "a0a8ba324aae03371d74fbf9ccb299f41456cc1ade63161c90a216b028c4256c" => :mavericks
    sha256 "344332d9ca503184f80ab8ea6505574316d4bd994070d86dc2ddc138b77e331e" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    # Makefile doesn't honor mandir, so move manpages post-install
    share.install prefix+"man"
  end
end
