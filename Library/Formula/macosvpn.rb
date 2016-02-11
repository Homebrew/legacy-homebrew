class Macosvpn < Formula
  desc "Create Mac OS VPNs programmatically"
  homepage "https://github.com/halo/macosvpn"
  url "https://github.com/halo/macosvpn/archive/0.1.4.tar.gz"
  sha256 "577a93fff84a6076a4f53da0406ee712522f37e88c1857ad54686b7b7d936fcb"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8c3cc9d7403c53bdfe3d164fc2fa00711f0d5ea2ebe55e26616a204ee07066d" => :el_capitan
    sha256 "1051f8e2aa5543853298466e37de75059fb8306bf3dba3e242158702b459018d" => :yosemite
    sha256 "f46d4474233ed96a42a6cd2dee7cb80efb198b13a35b426dded181e0be8be4d9" => :mavericks
  end

  depends_on :xcode => ["6.1", :build]

  def install
    xcodebuild
    bin.install "build/Release/macosvpn"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macosvpn version", 98)
  end
end
