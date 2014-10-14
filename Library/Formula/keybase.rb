require "formula"

class GPGDependency < Requirement
  fatal true
  default_formula "gpg"
  satisfy { which("gpg") || which("gpg2") }
end

class Keybase < Formula
  homepage "https://keybase.io/"
  url "https://github.com/keybase/node-client/archive/v0.7.2.tar.gz"
  sha1 "680574530bbe77ecdc1954057e5518240dd099c6"
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

  def caveats;<<-EOS.undent if which("gpg2") && !which("gpg")
      Run below command if you use gpg2 as keybase's backend
        keybase config gpg gpg2
    EOS
  end

  test do
    system "#{bin}/keybase", "id", "maria"
  end
end
