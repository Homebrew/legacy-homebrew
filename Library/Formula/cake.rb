class Cake < Formula
  desc "Cake (C# Make) is a build automation system with a C# DSL."
  homepage "http://cakebuild.net/"
  url "https://github.com/cake-build/cake/releases/download/v0.6.0/Cake-bin-v0.6.0.zip"
  sha256 "0d7eefc816d0f3f3ab2a0f438bbdf5d2b744c0ca243459f329ae9a3672115856"

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
