require "formula"

class GPGDependency < Requirement
  fatal true
  default_formula "gpg"
  satisfy { which("gpg") || which("gpg2") }
end

class Keybase < Formula
  homepage "https://keybase.io/"
  url "https://github.com/keybase/node-client/archive/v0.6.2.tar.gz"
  sha1 "709d40cc076578081715c243e1ca5d70d310aeea"
  head "https://github.com/keybase/node-client.git"

  bottle do
    cellar :any
    sha1 "898048106797a9ed93dff944f04356375265e28b" => :mavericks
    sha1 "fd511af7c2419f477b2b6ae0f8ce577219b0a594" => :mountain_lion
    sha1 "0d51d35222e6c233d501552036a329d42255a0c1" => :lion
  end

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
