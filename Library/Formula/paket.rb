class Paket < Formula
  desc "Package dependency manager for .NET"
  homepage "https://fsprojects.github.io/Paket/"
  version "1.14.0"
  url "https://github.com/fsprojects/Paket/archive/1.14.0.tar.gz"
  sha256 "a1825c27f1840117cae65132dfefa7d2c0d063dea1dc6b21c0c267775745347e"
  head "https://github.com/fsprojects/Paket.git"

  depends_on "mono" => :recommended

  def install
    system "./build.sh", "MergePaketTool"
    bin.install "bin/merged/paket.exe"
    (bin/"paket").write <<-EOS.undent
      #!/usr/bin/env bash
      exec mono #{bin}/paket.exe "\$@"
    EOS
  end

  test do
    system "paket init"
    assert (testpath/"paket.dependencies").exist?, "paket.dependencies file should be created"
  end
end
