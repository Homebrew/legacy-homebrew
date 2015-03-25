class Scriptcs < Formula
  homepage "https://github.com/scriptcs/scriptcs"
  url "https://github.com/scriptcs/scriptcs/archive/v0.14.0.tar.gz"
  sha256 "44060c7ae6eb156a0088e0f8c1a3e6523b5cd7d8c6961e628ba8d5a9df3998eb"

  bottle do
    cellar :any
    sha256 "067f9f65deee2c3ef357dd98ea69f7ad0c933bfaa133038ff17c23a74729e852" => :yosemite
    sha256 "7d655aefdd184550312511d4de69d492601f2a3f2aab0309d8bf4bf6494d8156" => :mavericks
    sha256 "c97d97de65c57debc8d4eab150d1e08c6d569a30670b1cece71e3d2fc4276a42" => :mountain_lion
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
