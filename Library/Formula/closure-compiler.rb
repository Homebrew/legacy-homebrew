class ClosureCompiler < Formula
  desc "JavaScript optimizing compiler"
  homepage "https://github.com/google/closure-compiler"
  url "https://github.com/google/closure-compiler/archive/maven-release-v20150609.tar.gz"
  sha256 "1f4c84f427dcbcb56c8ac101ba12141b88a7dcb794a206c03b98fcd30066cb19"
  head "https://github.com/google/closure-compiler.git"

  bottle do
    cellar :any
    sha256 "72e0992ba4be24216a35b4c19a7165f326d1b65ee92e528fab18390fe8e009f1" => :yosemite
    sha256 "eb17bd8c3de9ece500c9fdfe9c9cb2cf4920c8311f0ca7d649dafecd488e6ebe" => :mavericks
    sha256 "5c69940a23bc17167ff751a5e65945a08fb01ceaddabb8ea35579289730d819f" => :mountain_lion
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
