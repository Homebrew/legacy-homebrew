class F3 < Formula
  homepage "http://oss.digirati.com.br/f3/"
  url "https://github.com/AltraMayor/f3/archive/v5.0.tar.gz"
  sha1 "be28f55ea8450a388a0ea63dc1f810080d822d22"

  head "https://github.com/AltraMayor/f3.git"

  bottle do
    cellar :any
    sha1 "939ab204d6e1ff0be2c487fd6cce4ba5bcad66f7" => :yosemite
    sha1 "6ae3660786be6daa0641bbaaae7b7e66fc5f5886" => :mavericks
    sha1 "f83fb9c34469ea937f51874a70f3ec94d48980db" => :mountain_lion
  end

  def install
    system "make", "all"
    bin.install %w[f3read f3write]
    man1.install "f3read.1"
    man1.install_symlink "f3read.1" => "f3write.1"
  end

  test do
    system "#{bin}/f3read", testpath
  end
end
