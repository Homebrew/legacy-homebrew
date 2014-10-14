require "formula"

class Plantuml < Formula
  homepage "http://plantuml.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/plantuml/plantuml.8002.jar"
  sha1 "1a415831941c0f3f8715e6859c1b13f91ec43b5d"

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
