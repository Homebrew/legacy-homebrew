class Abcl < Formula
  desc "Armed Bear Common Lisp: a full implementation of Common Lisp"
  homepage "http://abcl.org"
  url "http://abcl.org/releases/1.3.3/abcl-src-1.3.3.tar.gz"
  sha256 "2186e3670bc9778472f5589109a79f13f0e487444e0602b6fcdc96b7c68f7d0f"
  head "http://abcl.org/svn/trunk/abcl/", :using => :svn

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
