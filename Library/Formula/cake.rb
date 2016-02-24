class Cake < Formula
  desc "'C# Make' is a build automation system with a C# DSL."
  homepage "http://cakebuild.net/"
  url "https://github.com/cake-build/cake/releases/download/v0.9.0/Cake-bin-v0.9.0.zip"
  sha256 "a5905588f076435f2a6674849eda1fe51e17636d8d8bd4966258320ff740c0b4"

  bottle :unneeded

  depends_on "mono" => :recommended

  def install
    libexec.install Dir["*.dll"]
    libexec.install Dir["*.exe"]
    libexec.install Dir["*.xml"]

    bin.mkpath
    (bin/"cake").write <<-EOS.undent
      #!/bin/bash
      mono #{libexec}/Cake.exe "$@"
    EOS
  end

  test do
    test_str = "Hello Homebrew"
    (testpath/"build.cake").write <<-EOS.undent

      var target = Argument ("target", "info");

      Task("info").Does(() =>
      {
        Information ("Hello Homebrew");
      });

      RunTarget ("info");

    EOS

    assert_match test_str, shell_output("#{bin}/cake ./build.cake").strip
  end
end
