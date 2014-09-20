require "formula"

class GPGDependency < Requirement
  fatal true
  default_formula "gpg"
  satisfy { which("gpg") || which("gpg2") }
end

class Keybase < Formula
  homepage "https://keybase.io/"
  url "https://github.com/keybase/node-client/archive/v0.6.0.tar.gz"
  sha1 "a94107eea16729f1d1f962f86c1e5769d1f6e494"
  head "https://github.com/keybase/node-client.git"

  depends_on "node"
  depends_on GPGDependency

  def install
    libexec.install Dir["*"]
    (bin/"keybase").write <<-EOS.undent
      #!/bin/sh
      export KEYBASE_BIN="#{bin}/keybase"
      exec "#{HOMEBREW_PREFIX}/opt/node/bin/node" "#{libexec}/bin/main.js" "$@"
    EOS
  end

  test do
    system "#{bin}/keybase", "id", "maria"
  end
end
