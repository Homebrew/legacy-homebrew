require "formula"

class Bfg < Formula
  homepage "http://rtyley.github.io/bfg-repo-cleaner/"
  url "http://repo1.maven.org/maven2/com/madgag/bfg/1.11.8/bfg-1.11.8.jar"
  sha1 "9834ed826f2b3f1da1f28f663e3c5b9cf807ab1e"

  def install
    libexec.install "bfg-1.11.8.jar"
    bin.write_jar_script libexec/"bfg-1.11.8.jar", "bfg"
  end

  test do
    system "#{bin}/bfg"
  end
end
