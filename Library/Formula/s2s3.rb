require "formula"

class NODEDependency < Requirement
  fatal true
  default_formula "node"
  satisfy { which("node") }
end

class S2s3 < Formula
  homepage "https://github.com/jfromaniello/s2s3"
  url "https://github.com/jfromaniello/s2s3/archive/v2.2.0.tar.gz"
  sha1 "036adb45f6f1d29976d4dcb9f77d9a6660ec423e"
  head "https://github.com/jfromaniello/s2s3.git"

  depends_on NODEDependency

  def install
    libexec.install Dir["*"]

    node_bin = "#{Formula["node"].opt_bin}/node"
    node_bin = which("node") unless File.exists?(node_bin)

    (bin/"s2s3").write <<-EOS.undent
      #!/bin/sh
      exec "#{node_bin}" "#{libexec}/bin/main" "$@"
    EOS
  end

  test do
    system "#{bin}/ss-to-s3", "--version"
  end
end
