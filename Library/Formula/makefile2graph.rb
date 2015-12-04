class Makefile2graph < Formula
  desc "Create a graph of dependencies from GNU-Make"
  homepage "https://github.com/lindenb/makefile2graph"
  url "https://github.com/lindenb/makefile2graph/archive/v1.5.0.tar.gz"
  sha256 "9464c6c1291609c211284a9889faedbab22ef504ce967b903630d57a27643b40"
  head "https://github.com/lindenb/makefile2graph.git"

  bottle do
    cellar :any
    sha256 "37aebae489e0f341f80417ec711e5c2817f5b8097c3493dcc11bc754bdd1b1cf" => :yosemite
    sha256 "0de3d4a2492797c3259798493e287ac2403f02254c6cfcf74948a16bcc4bcd0d" => :mavericks
    sha256 "52dea69b4d18c1c6fa451ab834a43e1ca57ba64d9efb4c63972126a387682040" => :mountain_lion
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
