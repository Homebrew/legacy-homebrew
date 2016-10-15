require "formula"

class Chisel < Formula
  homepage "https://github.com/facebook/chisel"
  url "https://github.com/facebook/chisel/archive/1.0.0.zip"
  sha1 "78e1c10d6e1e625291377aac1b27487d210bb04e"

  def install
    libexec.install Dir["*.py", "commands"]
    prefix.install "PATENTS"
  end

  def caveats; <<-EOS.undent
    Add the following line to ~/.lldbinit to load chisel when Xcode launches:
      command script import #{libexec}/fblldb.py
    EOS
  end

  test do
    xcode_path = `xcode-select --print-path`.strip
    lldb_rel_path = "Contents/SharedFrameworks/LLDB.framework/Resources/Python"
    ENV["PYTHONPATH"] = "#{xcode_path}/../../#{lldb_rel_path}"
    system "python #{libexec}/fblldb.py"
  end
end
