class Embulk < Formula
  desc "Data transfer between various databases, file formats and services"
  homepage "http://www.embulk.org/"
  url "https://bintray.com/artifact/download/embulk/maven/embulk-0.6.25.jar"
  sha256 "5c64622a0b1df117b6928e2710d5d6a9cd8dd55b8e2ee01e79eada40b303e335"

  bottle do
    cellar :any
    sha256 "119f18cd8960821c6471c4ac96dcbc3801e786b4853e3a68891c68e3a5ec06a5" => :yosemite
    sha256 "e6bcbf6bb5af67f2d497cb05408fc1c4d626fd3011a7ee65e76fda2e866eb1f2" => :mavericks
    sha256 "507ba927665752e730843b9cb36fade80ff2849b2a5b8e30eb4c34d2df2beb34" => :mountain_lion
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
