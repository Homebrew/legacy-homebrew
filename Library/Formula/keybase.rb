class Keybase < Formula
  homepage "https://keybase.io/"
  url "https://github.com/keybase/node-client/archive/v0.7.7.tar.gz"
  sha1 "360f0c621adb9f74bb74893880f42e09a6dd36c3"
  head "https://github.com/keybase/node-client.git"

  depends_on "node"
  depends_on :gpg

  def install
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
