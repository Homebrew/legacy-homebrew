class Gvp < Formula
  desc "Go versioning packager"
  homepage "https://github.com/pote/gvp"
  url "https://github.com/pote/gvp/archive/v0.2.0.tar.gz"
  sha1 "d05a2f04ba06127c95fb1d1fb10a2643d6d27ac6"

  bottle do
    cellar :any
    sha1 "f1b92b589cc6d28f1287e469ba07e49c9b7a2bac" => :yosemite
    sha1 "76979a476e5590b59cd063845810ab6dd5a01ab4" => :mavericks
    sha1 "ca229e3f90bf71121eb70112a52ffa0865a3ee5c" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/gvp", "init"
    assert File.directory? ".godeps/src"
  end
end
