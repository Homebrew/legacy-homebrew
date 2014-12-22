require "formula"

class F3 < Formula
  homepage "http://oss.digirati.com.br/f3/"
  url "https://github.com/AltraMayor/f3/archive/v3.0.tar.gz"
  sha1 "9e0d2ddec98c09be17b5d343bd6d5fac2606a963"

  head "https://github.com/AltraMayor/f3.git"

  bottle do
    cellar :any
    sha1 "939ab204d6e1ff0be2c487fd6cce4ba5bcad66f7" => :yosemite
    sha1 "6ae3660786be6daa0641bbaaae7b7e66fc5f5886" => :mavericks
    sha1 "f83fb9c34469ea937f51874a70f3ec94d48980db" => :mountain_lion
  end

  def install
    system "make", "mac"
    bin.install "f3read", "f3write"
    man1.install "f3read.1"
    man1.install_symlink "f3read.1" => "f3write.1"
  end

  test do
    system "#{bin}/f3read", testpath
  end
end
