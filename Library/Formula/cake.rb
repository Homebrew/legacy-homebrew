class Cake < Formula
  desc "Cake (C# Make) is a build automation system with a C# DSL."
  homepage "http://cakebuild.net/"
  url "https://github.com/cake-build/cake/releases/download/v0.5.1/Cake-bin-v0.5.1.zip"
  sha256 "ff431d845575b0be9e355caa9f44a82ea015d8b849eeafcdaee0904c3fb6da53"

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
