require "formula"

class Makefile2graph < Formula
  homepage "https://github.com/lindenb/makefile2graph"
  url "https://github.com/lindenb/makefile2graph/archive/stable1.2.tar.gz"
  sha1 "fd6799c23e4b9599f4caf23b0ce0993ab33362a8"
  head "https://github.com/lindenb/makefile2graph.git"

  bottle do
    cellar :any
    sha1 "17670db7e3a7e0b02ef812a6f7f803a9192dcf61" => :yosemite
    sha1 "88171840b729d628a7ab58fc1febe312d87a970e" => :mavericks
    sha1 "87b9cf5a1995046638de61c854b0c12f8457ed87" => :mountain_lion
  end

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
