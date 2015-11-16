class Chisel < Formula
  desc "Collection of LLDB commands to assist debugging iOS apps"
  homepage "https://github.com/facebook/chisel"
  url "https://github.com/facebook/chisel/archive/1.3.0.tar.gz"
  sha256 "6e8f64a1cb48b0937a98a7d62dc0c6de8cea5afa0040088b426d166e188a6f59"

  bottle :unneeded

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
    system "python", "#{libexec}/fblldb.py"
  end
end
