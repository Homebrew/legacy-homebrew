+require "formula"
+
+class Macchanger < Formula
+  homepage "https://github.com/acrogenesis/macchanger"
+  url "https://github.com/acrogenesis/macchanger/archive/v0.2.tar.gz"
+  sha1 "2cb85f2692969492b9923509f83089f5950b9053"
+
+  def install
+    bin.install "bin/macchanger"
+  end
+
+end
