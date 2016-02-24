class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "http://plantuml.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/plantuml/plantuml.8031.jar"
  sha256 "e3d31995634c464c3311eb423441b75ee36322caf3da078a9971e4fbb701da64"

  bottle :unneeded

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
