class Keybase < Formula
  homepage "https://keybase.io/"
  url "https://github.com/keybase/node-client/archive/v0.7.7.tar.gz"
  sha256 "ae08423181867d071b23acb3f359b7341532290014eb42775eb7384a7ea757dc"
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
