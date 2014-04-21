require 'formula'

class Plantuml < Formula
  homepage 'http://plantuml.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/plantuml/plantuml.7994.jar'
  sha1 'b1b619532674b159814ea620a4ec1059eee7faee'

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
