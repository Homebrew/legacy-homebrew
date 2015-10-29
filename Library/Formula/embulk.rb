class Embulk < Formula
  desc "Data transfer between various databases, file formats and services"
  homepage "http://www.embulk.org/"
  url "https://bintray.com/artifact/download/embulk/maven/embulk-0.7.6.jar"
  sha256 "a7c7ab3e6e1261ed45ec1291d0d8524b523380add18b3e43744e656f233d2cf5"

  bottle do
    cellar :any_skip_relocation
    sha256 "9649d3d3d37d857f507be6e7ed04fadd870ba693e2595be00ccbe7dda8251854" => :el_capitan
    sha256 "adf7b6dce5cb3c3d5fad309acd07135e370a0365dbc6e46eb2f692c77d6f8e35" => :yosemite
    sha256 "7c7553a274eb949d1c0a20187500f057d2cad12fcd17dc57f16f591e6b0023d1" => :mavericks
  end

  depends_on :java

  skip_clean "libexec"

  def install
    (libexec/"bin").install "embulk-#{version}.jar" => "embulk"
    bin.write_jar_script libexec/"bin/embulk", "embulk"
  end

  test do
    system bin/"embulk", "example", "./try1"
    system bin/"embulk", "guess", "./try1/example.yml", "-o", "config.yml"
    system bin/"embulk", "preview", "config.yml"
    system bin/"embulk", "run", "config.yml"
  end
end
