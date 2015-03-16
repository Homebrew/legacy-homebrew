class ClosureCompiler < Formula
  homepage "https://github.com/google/closure-compiler"
  url "https://github.com/google/closure-compiler/archive/maven-release-v20150126.tar.gz"
  sha256 "cedd1746f2e47bad781aaba9c80e5409906d09af309f05c03832dea05497e375"

  head "https://github.com/google/closure-compiler.git"

  bottle do
    cellar :any
    sha256 "89ffc8e227be05ab6386a6a2f3c60b806f0f98db89e307a35a930dec5f4ed45d" => :yosemite
    sha256 "55b6b55fe539b44963c023a0b0942a19bd33f99fc9b673580eca00660c45f505" => :mavericks
    sha256 "d7eb4c90796cfcad18f844781142c247639ce6be2452b7d1a129aa627bd3ab95" => :mountain_lion
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
