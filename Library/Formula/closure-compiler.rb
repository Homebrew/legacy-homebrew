class ClosureCompiler < Formula
  homepage "https://github.com/google/closure-compiler"
  url "https://github.com/google/closure-compiler/archive/maven-release-v20150126.tar.gz"
  sha256 "cedd1746f2e47bad781aaba9c80e5409906d09af309f05c03832dea05497e375"

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

  test do
    (testpath/"test.js").write <<-EOS.undent
      (function(){
        var t = true;
        return t;
      })();
    EOS
    system bin/"closure-compiler",
           "--js", testpath/"test.js",
           "--js_output_file", testpath/"out.js"
    assert_equal (testpath/"out.js").read.chomp, "(function(){return!0})();"
  end
end
