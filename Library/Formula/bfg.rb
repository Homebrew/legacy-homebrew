class Bfg < Formula
  homepage "https://rtyley.github.io/bfg-repo-cleaner/"
  url "https://repo1.maven.org/maven2/com/madgag/bfg/1.12.3/bfg-1.12.3.jar"
  sha1 "4eff57d0418958815681cbbec2f19ed7285252cb"

  bottle do
    cellar :any
    sha1 "7fde7526596e5070bb55723b6a03ccba698a3539" => :yosemite
    sha1 "8ba104dc6eb4a6ae562d103df5ef439462bc725e" => :mavericks
    sha1 "93b260fc22c0790d6a12d2eddbf2818728f29dd2" => :mountain_lion
  end

  def install
    libexec.install "bfg-1.12.3.jar"
    bin.write_jar_script libexec/"bfg-1.12.3.jar", "bfg"
  end

  test do
    system "#{bin}/bfg"
  end
end
