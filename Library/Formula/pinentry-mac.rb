require "formula"

class PinentryMac < Formula
  homepage "https://github.com/GPGTools/pinentry-mac"
  url "https://github.com/GPGTools/pinentry-mac/archive/v0.8.1.tar.gz"
  sha256 "79aaa11fa8076ff335b3a1f41c230ef7c8435a757705e6484199f562f26b490f"
  head "https://github.com/GPGTools/pinentry-mac.git"

  depends_on :xcode => :build

  def install
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
