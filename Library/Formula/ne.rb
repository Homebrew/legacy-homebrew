class Ne < Formula
  desc "The nice editor"
  homepage "http://ne.di.unimi.it"
  url "http://ne.di.unimi.it/ne-3.0.1.tar.gz"
  sha256 "92b646dd2ba64052e62deaa4239373821050a03e1b7d09d203ce04f2adfbd0e4"

  bottle do
    cellar :any_skip_relocation
    sha256 "56d04a63498270ddfed02081ab5970bcc5751a45468ff08b205d639d2e8878ff" => :el_capitan
    sha256 "78875d4f901208279d8d13da35d40d0fbe2278b549a0c33754280f77dcf864e1" => :yosemite
    sha256 "8b7072ee6e35427d7343af22811fb9af854788a14725b4fc6516f6872b273157" => :mavericks
  end

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
