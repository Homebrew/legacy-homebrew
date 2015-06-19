class PinentryMac < Formula
  desc "Pinentry for GPG on Mac"
  homepage "https://github.com/GPGTools/pinentry-mac"
  head "https://github.com/GPGTools/pinentry-mac.git"

  stable do
    url "https://github.com/GPGTools/pinentry-mac/archive/v0.8.1.tar.gz"
    sha256 "79aaa11fa8076ff335b3a1f41c230ef7c8435a757705e6484199f562f26b490f"

    # Removes the remote code execution previously run automatically.
    patch do
      url "https://github.com/GPGTools/pinentry-mac/commit/89dd4789818894.diff"
      sha1 "ab4db3264e1eb5ec9f9e1a31ad28b43d869c0f82"
    end
  end

  bottle do
    cellar :any
    revision 1
    sha1 "c4a4832d79deb076f727eebde1ca2a2148eb2104" => :yosemite
    sha1 "c3fceef899c53c1b16fb2262f31fa5b46d6c13f5" => :mavericks
    sha1 "49db48b86524242985fba13304a2c8116c087e6b" => :mountain_lion
  end

  # Manual cloning of this repo is now the upstream default:
  # https://github.com/GPGTools/pinentry-mac/commit/89dd47898188
  resource "core_clone" do
    url "https://github.com/GPGTools/GPGTools_Core.git",
        :revision => "f1e458ab2daeb104328ea4ec2aa7c71e8fca758d"
  end

  depends_on :xcode => :build

  def install
    (buildpath/"Dependencies/GPGTools_Core").install resource("core_clone")

    system "make"
    prefix.install "build/Release/pinentry-mac.app"
    bin.write_exec_script "#{prefix}/pinentry-mac.app/Contents/MacOS/pinentry-mac"
  end

  def caveats; <<-EOS.undent
    You can now set this as your pinentry program like

    ~/.gnupg/gpg-agent.conf
        pinentry-program #{HOMEBREW_PREFIX}/bin/pinentry-mac
    EOS
  end
end
