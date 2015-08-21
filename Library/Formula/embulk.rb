class Embulk < Formula
  desc "Data transfer between various databases, file formats and services"
  homepage "http://www.embulk.org/"
  url "https://bintray.com/artifact/download/embulk/maven/embulk-0.7.2.jar"
  sha256 "cb6d7f595645bd4b8944f6e4ffabb1f68bf6be1451801ee9df8db9ce4b305a09"

  bottle do
    cellar :any
    sha256 "44e1429b95e2e2f84b7f03a03b38eeb91590b1a74937710653c91c14afd42a1b" => :yosemite
    sha256 "c8763f8421c0ce1474555021e12e6a9eb1fce00f58e38f86f3938deddf5b838c" => :mavericks
    sha256 "3ebca8c668e52ce613118ce50bee7886eb12caea53c8ab7fccbf6ea7703b33f2" => :mountain_lion
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
