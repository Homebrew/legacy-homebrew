class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "http://plantuml.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/plantuml/plantuml.8029.jar"
  sha256 "632e57aebd6aa986fb0cf9d80d468abd10d7414f79b4d5637ef2adf0794f6106"

  bottle do
    cellar :any
    sha256 "fdaebfab0679dfe6022b0698e2a9574688a91e9b913697712e97c51b70156e0a" => :yosemite
    sha256 "62c5af2c0bea0e45170312ec7c7c9605f2d98d7d78bf60585213a96d354ddac0" => :mavericks
    sha256 "871d67e7675e0d9935c5394d4eb64b4048efd979c058b613b3729d4710d8d532" => :mountain_lion
  end

  depends_on "graphviz"

  def install
    jar = "plantuml.#{version}.jar"
    prefix.install jar
    bin.write_jar_script prefix/jar, "plantuml"
  end

  test do
    system "#{bin}/plantuml", "-testdot"
  end
end
