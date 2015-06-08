class Keybase < Formula
  desc "Command-line interface to Keybase.io"
  homepage "https://keybase.io/"
  url "https://github.com/keybase/node-client/archive/v0.7.9.tar.gz"
  sha256 "69798709139a8ff5a45886b8973abba17e55d76caa83ac86d6dfc262e858ec88"
  head "https://github.com/keybase/node-client.git"

  depends_on "node"
  depends_on :gpg

  def install
    # remove self-update command
    # https://github.com/keybase/keybase-issues/issues/1477
    rm "lib/command/update.js"
    inreplace "lib/command/all.js", '"update", ', ""
    inreplace "lib/req.js", "keybase-installer", "brew update && brew upgrade keybase"

    libexec.install Dir["*"]
    (bin/"keybase").write <<-EOS.undent
      #!/bin/sh
      export KEYBASE_BIN="#{bin}/keybase"
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/bin/main.js" "$@"
    EOS
  end

  test do
    system "#{bin}/keybase", "id", "maria"
  end
end
