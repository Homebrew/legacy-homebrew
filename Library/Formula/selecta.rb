class Ruby19Dependency < Requirement
  fatal true

  satisfy do
    ruby = which("ruby")
    `#{ruby} --version` =~ /ruby (\d\.\d).\d/
    $1.to_f >= 1.9
  end

  def message
    "Selecta requires Ruby 1.9 or greater."
  end
end

class Selecta < Formula
  homepage "https://github.com/garybernhardt/selecta"
  url "https://github.com/garybernhardt/selecta/archive/v0.0.6.tar.gz"
  sha1 "bf8881b2d545847921b1a05d23b88e2037c358e4"

  depends_on Ruby19Dependency

  def install
    bin.install "selecta"
  end

  test do
    system "#{bin}/selecta", "--version"
  end
end
