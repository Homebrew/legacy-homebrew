class Makefile2graph < Formula
  desc "Create a graph of dependencies from GNU-Make"
  homepage "https://github.com/lindenb/makefile2graph"
  url "https://github.com/lindenb/makefile2graph/archive/v1.5.0.tar.gz"
  sha256 "9464c6c1291609c211284a9889faedbab22ef504ce967b903630d57a27643b40"
  head "https://github.com/lindenb/makefile2graph.git"

  bottle do
    cellar :any
    sha1 "dd3b740ea2abc872fca365d6e6872b36cad8d10d" => :yosemite
    sha1 "eef36f040d63dd9df3ec69cb787b1ceea610bf42" => :mavericks
    sha1 "f2ae7bcf26c93031f82d15dc636885aff4c0b1da" => :mountain_lion
  end

  depends_on "graphviz" => :recommended

  def install
    system "make"
    system "make", "test" if build.with? "graphviz"
    bin.install "make2graph", "makefile2graph"
    man1.install "make2graph.1", "makefile2graph.1"
    doc.install "LICENSE", "README.md", "screenshot.png"
  end

  test do
    (testpath/"Makefile").write <<-EOS.undent
      all: foo
      all: bar
      foo: ook
      bar: ook
      ook:
    EOS
    system "make -Bnd >make-Bnd"
    system "#{bin}/make2graph <make-Bnd"
    system "#{bin}/make2graph --root <make-Bnd"
    system "#{bin}/makefile2graph"
  end
end
