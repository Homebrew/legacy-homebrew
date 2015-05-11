class RexsterConsole < Formula
  homepage "https://github.com/tinkerpop/rexster/wiki"
  url "http://tinkerpop.com/downloads/rexster/rexster-console-2.6.0.zip"
  sha256 "5f3af7bfc95847e8efa28610b23e2c175c6d92c14e5f3a468b9476cb1f2dfe1e"

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
