class RancherCompose < Formula
  desc "Docker compose compatible client to deploy to Rancher"
  homepage "https://github.com/rancher/rancher-compose"
  url "https://github.com/rancher/rancher-compose/archive/v0.5.1.tar.gz"
  sha256 "0344642752b0ecc2d1d396bbbd453afd0150f629acfc0fb018304a79898fc278"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad3c2279787e1de9c107f0aa68515ae3074f14079e5289e3ee24d008baa08a2e" => :el_capitan
    sha256 "73d6c1089c89d11c5a66f7beabfd4aff06d2d9ce54ac5428787595e4204ab5d3" => :yosemite
    sha256 "fea6ac6e4cdbe57667aaa34878766733fa51c61dd49aa25c08bf58fa726494ac" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = "#{buildpath}:#{buildpath}/Godeps/_workspace"
    mkdir_p "#{buildpath}/src/github.com/rancher"
    ln_s buildpath, "#{buildpath}/src/github.com/rancher/rancher-compose"
    system "go", "build", "-ldflags", "-w -X github.com/rancher/rancher-compose/version.VERSION #{version}", "-o", "#{bin}/rancher-compose"
  end

  test do
    system "#{bin}/rancher-compose", "help"
  end
end
