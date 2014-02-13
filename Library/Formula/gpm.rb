require "formula"

class Gpm < Formula
  homepage "https://github.com/pote/gpm"
  url "https://github.com/pote/gpm/archive/v1.0.0.tar.gz"
  sha1 "1bceb0af64c821fab01fe9606362d936343d6950"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "gpm help"
  end
end
