require "formula"

class GPGDependency < Requirement
  fatal true
  default_formula "gpg"
  satisfy { which("gpg") || which("gpg2") }
end

class Keybase < Formula
  homepage "https://keybase.io/"
  url "https://github.com/keybase/node-client/archive/v0.7.3.tar.gz"
  sha1 "379209b1b8ee3d66b764efddd5c1abc2c931b7e2"
  head "https://github.com/keybase/node-client.git"

  depends_on "node"
  depends_on GPGDependency

  def install
    libexec.install Dir["*"]
    (bin/"keybase").write <<-EOS.undent
      #!/bin/sh
      export KEYBASE_BIN="#{bin}/keybase"
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/bin/main.js" "$@"
    EOS
  end

  def caveats;<<-EOS.undent if which("gpg2") && !which("gpg")
      Run below command if you use gpg2 as keybase's backend
        keybase config gpg gpg2
    EOS
  end

  test do
    system "#{bin}/keybase", "id", "maria"
  end
end
