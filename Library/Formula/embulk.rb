class Embulk < Formula
  desc "Data transfer between various databases, file formats and services"
  homepage "http://www.embulk.org/"
  url "https://bintray.com/artifact/download/embulk/maven/embulk-0.7.4.jar"
  sha256 "848024baf8e940f1d0d1085588f28ca80e1ad5b9343ad9b942056132e30edaef"

  bottle do
    cellar :any
    sha256 "46efb139c4365e9dbeeb861393b51656fac30d75fab4695a9c52f61f0bed212c" => :yosemite
    sha256 "09b54755a268b755869b6217785dede4d5a88a2ad2ce03560c9fe47b92e758e9" => :mavericks
    sha256 "39e1dbf2a4911c44af8e661fd034dba3455e17ccdbc940c2452719c9b95f5ba8" => :mountain_lion
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
