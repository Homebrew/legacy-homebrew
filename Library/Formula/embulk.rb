class Embulk < Formula
  desc "Data transfer between various databases, file formats and services"
  homepage "http://www.embulk.org/"
  url "https://bintray.com/artifact/download/embulk/maven/embulk-0.6.19.jar"
  sha256 "6de93139322609ff26b77ddf51916d1fcd1b472a84073ac8d242552a64501781"

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
