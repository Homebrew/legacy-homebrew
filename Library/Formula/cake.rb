class Cake < Formula
  desc "Cake (C# Make) is a build automation system with a C# DSL."
  homepage "http://cakebuild.net/"
  url "https://github.com/cake-build/cake/releases/download/v0.5.3/Cake-bin-v0.5.3.zip"
  sha256 "74fd7387611e982365c17f0fadb021627be96d4e7449ee1796489ecd455a42e8"

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
