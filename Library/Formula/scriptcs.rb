class Scriptcs < Formula
  desc "Tools to write and execute C#"
  homepage "https://github.com/scriptcs/scriptcs"
  url "https://github.com/scriptcs/scriptcs/archive/v0.15.0.tar.gz"
  sha256 "658d4ef2c23253ba1d2717c947d2985cb506ce69425280ee8e62cc50d15d6803"

  bottle do
    cellar :any
    sha256 "037322cb22364e6f5f04dc0bbe44e61d70563c1a11b4720e008fc9c75a38c0c1" => :yosemite
    sha256 "a0fa33747394a09593296c2a8b79d2c91e969e513e3b51134064ee764b178526" => :mavericks
    sha256 "618d93786fe7db150874329ff1339cb383c5b423779dae289bb4ce12db7de8dc" => :mountain_lion
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
