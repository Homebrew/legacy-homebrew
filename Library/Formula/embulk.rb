class Embulk < Formula
  desc "Data transfer between various databases, file formats and services"
  homepage "http://www.embulk.org/"
  url "https://bintray.com/artifact/download/embulk/maven/embulk-0.6.12.jar"
  sha256 "440be2dc34e6f3346fc808ece4c7ab713dbcea90c992149d56f407cf264c2598"

  depends_on :java

  skip_clean "libexec"

  def install
    (libexec/"bin").install "embulk-0.6.12.jar" => "embulk"
    chmod 0755, libexec/"bin/embulk"
    bin.write_exec_script libexec/"bin/embulk"
  end

  test do
    system "embulk", "example", "./try1"
    system "embulk", "guess", "./try1/example.yml", "-o", "config.yml"
    system "embulk", "preview", "config.yml"
    system "embulk", "run", "config.yml"
  end
end
