class Embulk < Formula
  desc "Data transfer between various databases, file formats and services"
  homepage "http://www.embulk.org/"
  url "https://bintray.com/artifact/download/embulk/maven/embulk-0.7.3.jar"
  sha256 "197be338e00a58aeb76a622d78ecd66cfa75943e9a462bd658b7bf7ae9688b74"

  bottle do
    cellar :any
    sha256 "37b9402656fd49b3d5e1d0987b366eb91f5399516c575c6c11e40770d607e105" => :yosemite
    sha256 "992988803272501378f51af82850ccd8a3df31e31c21886f6f721c4cbe7b39fa" => :mavericks
    sha256 "e7ba8b67d39a6157ae637c03c4727d82f46471fe303769a448f32cd70c910e15" => :mountain_lion
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
