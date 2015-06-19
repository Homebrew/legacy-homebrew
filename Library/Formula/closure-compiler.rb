class ClosureCompiler < Formula
  desc "JavaScript optimizing compiler"
  homepage "https://github.com/google/closure-compiler"
  url "https://github.com/google/closure-compiler/archive/maven-release-v20150315.tar.gz"
  sha256 "9e4ad6367913f1b2f3b3a3a9d68dc4779144336b06aa9732dd0a6caca2d83ba1"
  head "https://github.com/google/closure-compiler.git"

  bottle do
    cellar :any
    sha256 "03bf823ee5f71f31c88ed4a412506bb7e0af4eb90f608d89aae86ac0d0828fec" => :yosemite
    sha256 "94a4040f31ff31c318906e6fbf757cf3669b700a9ed07f9d665abbed30444575" => :mavericks
    sha256 "e2609e83ace94265ebbbeeff90e3b2599917375eb5aecaaa694ba2998dea86c6" => :mountain_lion
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
