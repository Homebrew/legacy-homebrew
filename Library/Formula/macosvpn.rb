class Macosvpn < Formula
  desc "Create Mac OS VPNs programmatically"
  homepage "https://github.com/halo/macosvpn"
  url "https://github.com/halo/macosvpn/archive/0.1.4.tar.gz"
  sha256 "577a93fff84a6076a4f53da0406ee712522f37e88c1857ad54686b7b7d936fcb"

  depends_on :xcode => ["6.1", :build]

  def install
    xcodebuild
    bin.install "build/Release/macosvpn"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macosvpn version", 98)
  end
end
