class Sparse < Formula
  desc "Static C code analysis tool"
  homepage "https://sparse.wiki.kernel.org/"
  url "https://www.kernel.org/pub/software/devel/sparse/dist/sparse-0.5.0.tar.xz"
  sha256 "921fcf918c6778d1359f3886ac8cb4cf632faa6242627bc2ae2db75e983488d5"
  head "https://git.kernel.org/pub/scm/devel/sparse/sparse.git"

  bottle do
    cellar :any
    sha256 "be1693a0ec2050625898d960ffd99468d4ce7471785fe1ae6d6f373da2416b11" => :yosemite
    sha256 "4c33d0589d81abda44fef8904892dc7f6361e96caa82012a71101e9fefe4425c" => :mavericks
    sha256 "6dac58ce04e796731ea3f0ed3a239cbe6334ab54648f4238baf60d64c1d04437" => :mountain_lion
  end

  def install
    inreplace "Makefile", /PREFIX=\$\(HOME\)/, "PREFIX=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.C").write("int main(int a) {return a;}\n")
    system "#{bin}/sparse", testpath/"test.C"
  end
end
