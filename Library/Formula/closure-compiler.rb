class ClosureCompiler < Formula
  desc "JavaScript optimizing compiler"
  homepage "https://github.com/google/closure-compiler"
  url "https://github.com/google/closure-compiler/archive/maven-release-v20160208.tar.gz"
  sha256 "7d4a5f73d6c65e7cb908d7b5183e3e11215f6424b9dd498036c422dd6897401c"
  head "https://github.com/google/closure-compiler.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a01234e04404b2cda2ed103190ceb316b70cddaed92b58a6dc2fcb6a324b5f77" => :el_capitan
    sha256 "fbca34b70df49ed4981e04478691f0a5f27ea3b806e7e8ce03d0bed78acb910b" => :yosemite
    sha256 "84f00517bf2ac14b666a6c9c577c0365bed38a564e85f9cc5533d1f45be237d3" => :mavericks
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
