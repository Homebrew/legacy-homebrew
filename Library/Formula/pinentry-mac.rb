class PinentryMac < Formula
  desc "Pinentry for GPG on Mac"
  homepage "https://github.com/GPGTools/pinentry-mac"
  head "https://github.com/GPGTools/pinentry-mac.git"

  stable do
    url "https://github.com/GPGTools/pinentry-mac/archive/v0.9.4.tar.gz"
    sha256 "037ebb010377d3a3879ae2a832cefc4513f5c397d7d887d7b86b4e5d9a628271"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c3d508c96256c50b6a62f9e64fc4cb28810a910927c21f7defbe8af11a3c5961" => :el_capitan
    sha256 "b96a51a263a9447101d4bb8dc4247f324531bd4fd96218f6e170edfc983a87f7" => :yosemite
    sha256 "c2538b57edce2eb7ccc10a32e16ccfbbbe8e61c384c4db8d5a62b04d3815c0ed" => :mavericks
    sha256 "0d6eb6b84a6389e208d4ec055d5f10f84b48bad94d00e9599b9aafb3dfaf71d8" => :mountain_lion
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
