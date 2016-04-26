class Abcl < Formula
  desc "Armed Bear Common Lisp: a full implementation of Common Lisp"
  homepage "http://abcl.org"
  url "http://abcl.org/releases/1.3.3/abcl-src-1.3.3.tar.gz"
  sha256 "2186e3670bc9778472f5589109a79f13f0e487444e0602b6fcdc96b7c68f7d0f"
  head "http://abcl.org/svn/trunk/abcl/", :using => :svn

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "07238d63939ab91c3d9f0c66cb0214e22a2a87d928c8118a59eaf3400f9c5e6f" => :el_capitan
    sha256 "6baf2c9e04b9bdded093234f797dcdab93d980ca941e74c8a9d44f7bc59a8b6d" => :yosemite
    sha256 "8a4fa7e13d476419b446b7efa99d3d2e380cf468ec9e9f5c311ef6e1d71847d0" => :mavericks
  end

  depends_on "ant"
  depends_on :java => "1.5+"
  depends_on "rlwrap" => :recommended

  def install
    ENV.java_cache
    system "ant"

    libexec.install "dist/abcl.jar", "dist/abcl-contrib.jar"
    (bin/"abcl").write <<-EOS.undent
      #!/bin/sh
      #{"rlwrap " if build.with?("rlwrap")}java -cp #{libexec}/abcl.jar:"$CLASSPATH" org.armedbear.lisp.Main "$@"
    EOS
  end

  test do
    (testpath/"test.lisp").write "(print \"Homebrew\")\n(quit)"
    assert_match /"Homebrew"$/, shell_output("#{bin}/abcl --load test.lisp").strip
  end
end
