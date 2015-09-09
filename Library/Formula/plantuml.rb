class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "http://plantuml.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/plantuml/plantuml.8029.jar"
  sha256 "632e57aebd6aa986fb0cf9d80d468abd10d7414f79b4d5637ef2adf0794f6106"

  bottle do
    cellar :any
    sha256 "07710e1822d0d984aebfee3a59583a1f593530a3e08a21b7ce3b8b60e4138aec" => :yosemite
    sha256 "60cbe90a7e1f0020db1c56f5bfd0b4a5dec946456dc7afd019a40245bfff57fc" => :mavericks
    sha256 "747e7004c64f56517e9868785497bc978755aaec15c0fae86c7cc4045ae9b8b4" => :mountain_lion
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
