class ClosureCompiler < Formula
  homepage "https://github.com/google/closure-compiler"
  url "https://github.com/google/closure-compiler/archive/maven-release-v20150126.tar.gz"
  sha1 "2d21bd4faf8a982346d390391d7f6d0e60fe571b"

  head "https://github.com/google/closure-compiler.git"

  bottle do
    cellar :any
    sha1 "4948b02aa41ae8979325f759116750a72b14feff" => :yosemite
    sha1 "2d99973cfa238d61b2beab10005494b5b61b73ca" => :mavericks
    sha1 "68df5948864090eab5b2f221b2d6f7fea3e9e3b8" => :mountain_lion
  end

  depends_on :ant => :build
  depends_on :java => "1.7+"

  def install
    system "ant", "clean"
    system "ant"

    libexec.install Dir["*"]
    bin.write_jar_script libexec/"build/compiler.jar", "closure-compiler"
  end
end
