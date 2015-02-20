class Gvp < Formula
  homepage "https://github.com/pote/gvp"
  url "https://github.com/pote/gvp/archive/v0.2.0.tar.gz"
  sha1 "d05a2f04ba06127c95fb1d1fb10a2643d6d27ac6"

  bottle do
    cellar :any
    sha1 "06092cbaeda1a2e565868dd27eb8d71ce62d0477" => :mavericks
    sha1 "79eadbc9c59afd18e6406773892269519ecbfc6e" => :mountain_lion
    sha1 "ae36dae26ce09281e6bf173f53eca9a7da56d97b" => :lion
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
