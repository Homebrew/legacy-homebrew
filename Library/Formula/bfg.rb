require "formula"

class Bfg < Formula
  homepage "http://rtyley.github.io/bfg-repo-cleaner/"
  url "http://repo1.maven.org/maven2/com/madgag/bfg/1.11.6/bfg-1.11.6.jar"
  sha1 "bbe33eb231435c04f5713d05d3b17a9b88d4954e"

  def install
    libexec.install "bfg-1.11.6.jar"
    bin.write_jar_script libexec/"bfg-1.11.6.jar", "bfg"
  end

  test do
    system "#{bin}/bfg"
  end
end
