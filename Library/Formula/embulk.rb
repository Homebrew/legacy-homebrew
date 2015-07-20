class Embulk < Formula
  desc "Data transfer between various databases, file formats and services"
  homepage "http://www.embulk.org/"
  url "https://bintray.com/artifact/download/embulk/maven/embulk-0.6.17.jar"
  sha256 "68c884d84663ecc821ed327b13b90ad826ba8d5e998f422cfce6cc9745a086c6"

  depends_on :java

  skip_clean "libexec"

  def install
    (libexec/"bin").install "embulk-0.6.17.jar" => "embulk"
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
