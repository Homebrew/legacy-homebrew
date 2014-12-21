class Chapel < Formula
  homepage "http://chapel.cray.com/"
  url "https://github.com/chapel-lang/chapel/releases/download/1.10.0/chapel-1.10.0.tar.gz"
  sha1 "9c05c48f9309a7f685390df37753c086d1637c96"
  head "https://github.com/chapel-lang/chapel.git"

  def install
    # Remove the deparallelize with the 1.11.0 release, circa April 2015.
    ENV.deparallelize

    libexec.install Dir["*"]
    # Chapel uses this ENV to work out where to install.
    ENV["CHPL_HOME"] = libexec

    # Must be built from within CHPL_HOME to prevent build bugs.
    # https://gist.github.com/DomT4/90dbcabcc15e5d4f786d
    # https://github.com/Homebrew/homebrew/pull/35166
    cd libexec do
      system "make", "all"
    end

    prefix.install_metafiles

    (bin/"chpl").write_env_script libexec/"bin/darwin/chpl", :CHPL_HOME => libexec
    man1.install_symlink Dir["#{libexec}/man/man1/*.1"]
  end

  test do
    (testpath/"hello.chpl").write "writeln('Hello, world!');"
    system "#{bin}/chpl", "-o", "hello", "hello.chpl"
    assert_equal "Hello, world!", shell_output("./hello").strip
  end
end
