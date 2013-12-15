require 'formula'

class Plantuml < Formula
  homepage 'http://plantuml.sourceforge.net/'
  url 'http://sourceforge.net/projects/plantuml/files/plantuml.7987.jar'
  sha1 '69beeb97a982b71fefd5ec5637de18b498910b13'

  depends_on 'graphviz'

  def install
    jar = "plantuml.#{version}.jar"
    prefix.install jar
    bin.write_jar_script prefix/jar, "plantuml"
  end

  test do
    system "#{bin}/plantuml", "-testdot"
  end
end
