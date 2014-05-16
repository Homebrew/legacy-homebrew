require "formula"

class RexsterConsole < Formula
  homepage "https://github.com/tinkerpop/rexster/wiki"
  url "http://tinkerpop.com/downloads/rexster/rexster-console-2.5.0.zip"
  sha1 "0243908c0ab65baea4b8092bb2b818c597622187"

  def install
    prefix.install %w[lib doc]
    bin.install "bin/rexster-console.sh" => "rexster-console"
  end

  test do
    system "#{bin}/rexster-console", "-h"
  end
end
