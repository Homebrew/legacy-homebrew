class Gti < Formula
  homepage "http://r-wos.org/hacks/gti"
  url "https://github.com/rwos/gti/archive/v1.2.0.tar.gz"
  sha256 "e76a3d44610c1445263860391f8243cde622f58945101075f750e96d96063762"

  head "https://github.com/rwos/gti.git"

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "gti"
    man6.install "gti.6"
  end

  test do
    system "#{bin}/gti", "init"
  end
end
