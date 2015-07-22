class PinentryMac < Formula
  desc "Pinentry for GPG on Mac"
  homepage "https://github.com/GPGTools/pinentry-mac"
  head "https://github.com/GPGTools/pinentry-mac.git"

  stable do
    url "https://github.com/GPGTools/pinentry-mac/archive/v0.9.4.tar.gz"
    sha256 "037ebb010377d3a3879ae2a832cefc4513f5c397d7d887d7b86b4e5d9a628271"
  end

  bottle do
    cellar :any
    revision 1
    sha1 "c4a4832d79deb076f727eebde1ca2a2148eb2104" => :yosemite
    sha1 "c3fceef899c53c1b16fb2262f31fa5b46d6c13f5" => :mavericks
    sha1 "49db48b86524242985fba13304a2c8116c087e6b" => :mountain_lion
  end

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
