class Scriptcs < Formula
  homepage "https://github.com/scriptcs/scriptcs"
  url "https://github.com/scriptcs/scriptcs/archive/v0.13.3.tar.gz"
  sha256 "08cf6f2fc14b334ec8d18367a47e5210e99928c3c1cd3d16f2e94d596c8ab44a"

  bottle do
    cellar :any
    sha256 "bb55a2043f8572b9476871f50c63253b409e69f4343c1598628e336f766756fa" => :yosemite
    sha256 "52e4caac203ae3d0876329a1484935daf1eff1c005b09fb4e3c29e032eb2f0b6" => :mavericks
    sha256 "3b7c04358ddc452d2e0ba114c40cf3973bcd4f65385297423207a0b79a9d52d7" => :mountain_lion
  end

  depends_on "mono" => :recommended

  def install
    script_file = "scriptcs.sh"
    system "./build.sh"
    libexec.install Dir["src/ScriptCs/bin/Release/*"]
    (libexec/script_file).write <<-EOS.undent
      #!/bin/bash
      mono #{libexec}/scriptcs.exe $@
    EOS
    (libexec/script_file).chmod 0755
    bin.install_symlink libexec/script_file => "scriptcs"
  end

  test do
    test_file = "tests.csx"
    (testpath/test_file).write('Console.WriteLine("{0}, {1}!", "Hello", "world");')
    assert_equal "Hello, world!", `scriptcs #{test_file}`.strip
  end
end
