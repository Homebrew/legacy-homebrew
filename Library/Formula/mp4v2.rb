require "formula"

class Mp4v2 < Formula
  homepage "http://code.google.com/p/mp4v2/"
  url "https://mp4v2.googlecode.com/files/mp4v2-2.0.0.tar.bz2"
  sha1 "193260cfb7201e6ec250137bcca1468d4d20e2f0"

  bottle do
    cellar :any
    sha1 "d7bce18055cddaaf13429b96dec5cecf60536ade" => :mavericks
    sha1 "d862406a423a2587bfac793d482dae6391f70822" => :mountain_lion
    sha1 "abfa572954faff663b79c1d03ef08f469faa65af" => :lion
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make"
    system "make install"
    system "make install-man"
  end
end
