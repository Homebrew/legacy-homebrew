class Keybase < Formula
  desc "Command-line interface to Keybase.io"
  homepage "https://keybase.io/"
  url "https://github.com/keybase/node-client/archive/v0.8.18.tar.gz"
  sha256 "c1ef27f959401164e72fbcd5c4054d13258a3f09dcdebb0ac3c447519780d59e"
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
    # Keybase requires a valid GPG keychain to be set up. Fetch Homebrew's pubkey.
    system "gpg", "--keyserver", "pgp.mit.edu", "--recv-keys", "0xE33A3D3CCE59E297"
    system "#{bin}/keybase", "id", "homebrew"
  end
end
