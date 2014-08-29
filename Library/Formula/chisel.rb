require "formula"

class Chisel < Formula
  homepage "https://github.com/facebook/chisel"
  url "https://github.com/facebook/chisel/archive/1.1.0.tar.gz"
  sha1 "d137fec38a8f9e1795331c6a340e7a5f43214b12"

  def install
    libexec.install Dir["*.py", "commands"]
    prefix.install "PATENTS"
  end

  def caveats; <<-EOS.undent
    Add the following line to ~/.lldbinit to load chisel when Xcode launches:
      command script import #{opt_libexec}/fblldb.py
    EOS
  end

  test do
    xcode_path = `xcode-select --print-path`.strip
    lldb_rel_path = "Contents/SharedFrameworks/LLDB.framework/Resources/Python"
    ENV["PYTHONPATH"] = "#{xcode_path}/../../#{lldb_rel_path}"
    system "python #{libexec}/fblldb.py"
  end
end
