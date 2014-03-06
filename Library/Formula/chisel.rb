require "formula"

class Chisel < Formula
  homepage "https://github.com/facebook/chisel"
  url "https://github.com/facebook/chisel/archive/1.0.0.zip"
  sha1 "78e1c10d6e1e625291377aac1b27487d210bb04e"

  def install
    prefix.install Dir["*"]
  end

  def caveats; <<-EOS.undent
    You may want to add the following line to your ~/.lldbinit file:
      command source #{prefix}/fblldb.py
  EOS
  end
end
