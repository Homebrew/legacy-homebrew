require "formula"

class Makefile2graph < Formula
  homepage "https://github.com/lindenb/makefile2graph"
  url "https://github.com/lindenb/makefile2graph/archive/stable1.2.tar.gz"
  sha1 "fd6799c23e4b9599f4caf23b0ce0993ab33362a8"
  head "https://github.com/lindenb/makefile2graph.git"

  depends_on "graphviz" => :recommended

  def install
    system "make"
    system "make", "test" if build.with? "graphviz"
    bin.install "make2graph"
    man1.install "make2graph.1"
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
    system "#{bin}/make2graph -x <make-Bnd"
  end
end
