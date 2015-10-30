class Ne < Formula
  desc "The nice editor"
  homepage "http://ne.di.unimi.it"
  url "http://ne.di.unimi.it/ne-3.0.1.tar.gz"
  sha256 "92b646dd2ba64052e62deaa4239373821050a03e1b7d09d203ce04f2adfbd0e4"

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    ENV["TERM"] = "xterm"
    (testpath/"test.txt").write("This is a test document.\n")
    (testpath/"test_ne").write("GotoLine 2\nInsertString line 2\nExit\n")
    system "script", "-q", "/dev/null", "#{bin}/ne", "--macro", "#{(testpath/"test_ne")}", "#{(testpath/"test.txt")}"
    assert_equal "This is a test document.\nline 2", File.read("#{testpath}/test.txt")
  end
end
