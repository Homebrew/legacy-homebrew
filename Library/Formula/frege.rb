require "formula"

class Frege < Formula
  homepage "https://github.com/Frege/frege/"
  url "https://github.com/Frege/frege/releases/download/3.21.500/frege3.21.500-g88270a0.jar"
  version "3.21.500-g88270a0"
  sha1 "4a6d504a5e5f3c3c3176c9ccf9e17276990ee772"

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"frege#{version}.jar", "fregec", "-Xss1m"
  end
end
