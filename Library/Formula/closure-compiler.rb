class ClosureCompiler < Formula
  desc "JavaScript optimizing compiler"
  homepage "https://github.com/google/closure-compiler"
  url "https://github.com/google/closure-compiler/archive/maven-release-v20160208.tar.gz"
  sha256 "7d4a5f73d6c65e7cb908d7b5183e3e11215f6424b9dd498036c422dd6897401c"
  head "https://github.com/google/closure-compiler.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "042e65a6e430d02cabdada6b30e9ff03a9894748bdf395efde020740eee50fdd" => :el_capitan
    sha256 "174a12e056a5c62e6b35b5b5aa4b7fbc32b5bf22e352b029348b5c2185fc7e96" => :yosemite
    sha256 "3bcf1652d33c42f3508ce5655db61103b4fe2b98b34c996138daf6212cf6e2cf" => :mavericks
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
