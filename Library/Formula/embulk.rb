class Embulk < Formula
  desc "Data transfer between various databases, file formats and services"
  homepage "http://www.embulk.org/"
  url "https://bintray.com/artifact/download/embulk/maven/embulk-0.6.5.jar"
  sha256 "fdb45887060777f3b216793c256959fa6018bab516dbcebfb95648a1a78839c8"

  depends_on :java

  skip_clean "libexec"

  def install
    (libexec/"bin").install "embulk-0.6.5.jar" => "embulk"
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
