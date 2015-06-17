class Sparse < Formula
  desc "Static C code analysis tool"
  homepage "https://sparse.wiki.kernel.org/"
  url "https://www.kernel.org/pub/software/devel/sparse/dist/sparse-0.5.0.tar.xz"
  sha256 "921fcf918c6778d1359f3886ac8cb4cf632faa6242627bc2ae2db75e983488d5"
  head "https://git.kernel.org/pub/scm/devel/sparse/sparse.git"

  def install
    inreplace "Makefile", /PREFIX=\$\(HOME\)/, "PREFIX=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.C").write("int main(int a) {return a;}\n")
    system "#{bin}/sparse", testpath/"test.C"
  end
end
