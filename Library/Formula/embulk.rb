class Embulk < Formula
  desc "Data transfer between various databases, file formats and services"
  homepage "http://www.embulk.org/"
  url "https://bintray.com/artifact/download/embulk/maven/embulk-0.7.5.jar"
  sha256 "9ddfdd8e32f92e2c1ed3115be110edf5cafcc535c343c256abfd72a2c88ab310"

  bottle do
    cellar :any_skip_relocation
    sha256 "5afbaac71962edc119c7ca6a5e1cfabf449171b79cd9b11604b4c83e9f348c9b" => :el_capitan
    sha256 "c66de40c2ab32dd382f7ee2977b797057942e16b87687b4339aa887b5d73b400" => :yosemite
    sha256 "a690038d489061b42c381d081ce1376da3e41f381926feb3628d7b0deecfd233" => :mavericks
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
