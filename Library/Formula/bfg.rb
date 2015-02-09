class Bfg < Formula
  homepage "https://rtyley.github.io/bfg-repo-cleaner/"
  url "https://repo1.maven.org/maven2/com/madgag/bfg/1.12.0/bfg-1.12.0.jar"
  sha1 "665b78b35a501adc49816e0553d643b56f05043f"

  bottle do
    cellar :any
    sha1 "7fde7526596e5070bb55723b6a03ccba698a3539" => :yosemite
    sha1 "8ba104dc6eb4a6ae562d103df5ef439462bc725e" => :mavericks
    sha1 "93b260fc22c0790d6a12d2eddbf2818728f29dd2" => :mountain_lion
  end

  def install
    libexec.install "bfg-1.12.0.jar"
    bin.write_jar_script libexec/"bfg-1.12.0.jar", "bfg"
  end

  test do
    system "#{bin}/bfg"
  end
end
