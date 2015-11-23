class ClosureCompiler < Formula
  desc "JavaScript optimizing compiler"
  homepage "https://github.com/google/closure-compiler"
  url "https://github.com/google/closure-compiler/archive/maven-release-v20150901.tar.gz"
  sha256 "f969407699516ac0e9c92be077ab5d04f177a5bbb391fd32dd06f029256d43eb"
  head "https://github.com/google/closure-compiler.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc38c9cf78a05755c56902bd91140518c8cac8882b96c4720aafdb980313e49a" => :el_capitan
    sha256 "c10eeaacd57d11f9550854b473bd949aa4bd0b039d8eac4788c1afeebf5e847e" => :yosemite
    sha256 "a4182e1f6061f795977120b3327b9006fe70ef49e69820282c472a0089382ab0" => :mavericks
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
