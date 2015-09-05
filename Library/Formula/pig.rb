class Pig < Formula
  desc "Platform for analyzing large data sets"
  homepage "https://pig.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=pig/pig-0.15.0/pig-0.15.0.tar.gz"
  mirror "https://archive.apache.org/dist/pig/pig-0.15.0/pig-0.15.0.tar.gz"
  sha256 "c52112ca618daaca298cf068e6451449fe946e8dccd812d56f8f537aa275234b"

  bottle do
    cellar :any
    sha256 "c937d3472443b64d1f7cbbd1e98caf1bee32787b02be552d0b82f3e1d44225e2" => :yosemite
    sha256 "1a6a720a36bf3b9812caee860828b028b253190f9cfcc73078afcf6e251176f2" => :mavericks
    sha256 "ce4626cd10cb18e6c1ef25fee0e6a10a47be587d2913b48fdee0f4ede1a9dc25" => :mountain_lion
  end

  depends_on :java

  def install
    (libexec/"bin").install "bin/pig"
    libexec.install ["pig-#{version}-core-h1.jar", "pig-#{version}-core-h2.jar", "lib"]
    (bin/"pig").write_env_script libexec/"bin/pig", Language::Java.java_home_env.merge(:PIG_HOME => libexec)
  end

  test do
    (testpath/"test.pig").write <<-EOS.undent
      sh echo "Hello World"
    EOS
    assert_match /Hello World/, shell_output("#{bin}/pig -x local test.pig")
  end
end
