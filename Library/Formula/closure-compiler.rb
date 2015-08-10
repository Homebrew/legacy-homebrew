class ClosureCompiler < Formula
  desc "JavaScript optimizing compiler"
  homepage "https://github.com/google/closure-compiler"
  url "https://github.com/google/closure-compiler/archive/maven-release-v20150729.tar.gz"
  sha256 "6564bd642e25154da0364f964deb02710a3952066954fe082bacd0b85d965d54"
  head "https://github.com/google/closure-compiler.git"

  bottle do
    cellar :any
    sha256 "904cc70d5bf207b8e0306b7e2ccbbfbf91732e6ac1ee0f7d55c15e8a45d79644" => :yosemite
    sha256 "a7e8f3502ce9d1604d75ae1af6293caf8c888d5185d060ae88fdab8cbbc32f94" => :mavericks
    sha256 "34ab6fa29a3c22ec2951882b0f31e1aef2457b363590e516511dbb5376cd546e" => :mountain_lion
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
