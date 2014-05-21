require "formula"

class Plantuml < Formula
  homepage "http://plantuml.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/plantuml/plantuml.7999.jar"
  sha1 "97215ec19934d15e247ff54e25a77a4483608d04"

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
