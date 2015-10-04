class RexsterConsole < Formula
  desc "Graph server exposing Blueprints graph via REST"
  homepage "https://github.com/tinkerpop/rexster/wiki"
  url "http://tinkerpop.com/downloads/rexster/rexster-console-2.6.0.zip"
  sha256 "5f3af7bfc95847e8efa28610b23e2c175c6d92c14e5f3a468b9476cb1f2dfe1e"

  bottle do
    cellar :any
    sha256 "affe578e75691159a7a850c8b144eaaabc58d8375d7172852069b951ddc88239" => :yosemite
    sha256 "17254b31620dc42f4ee9c49a7bba38a1506312939dcf8d2a54a16f1a6cafd2e6" => :mavericks
    sha256 "a9dd91d430d35af266e9298d3bae82445f6cbf0521cb615f5cbc854974b89308" => :mountain_lion
  end

  def install
    libexec.install %w[lib doc]
    (libexec/"ext").mkpath
    (libexec/"bin").install "bin/rexster-console.sh" => "rexster-console"
    bin.install_symlink libexec/"bin/rexster-console"
  end

  test do
    system "#{bin}/rexster-console", "-h"
  end
end
