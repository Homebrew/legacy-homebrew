class Fleetctl < Formula
  desc "Distributed init system"
  homepage "https://github.com/coreos/fleet"
  url "https://github.com/coreos/fleet/archive/v0.11.5.tar.gz"
  sha256 "a6a785099df71645b5fe8755a36baa6c11138749bc02ae4990fd3f52663c0394"
  head "https://github.com/coreos/fleet.git"

  bottle do
    cellar :any
    sha256 "4bbaed28515a733e185f458957255c5d204809f9e3d8d7311c135b27f396994a" => :yosemite
    sha256 "777e5941b1887ea48526a529f540604eec39bf29512de85af20ae6594548a4be" => :mavericks
    sha256 "fd0cea420fbb86293b012c3c58ba391894f61444eb45d40eef968347d05bd0e7" => :mountain_lion
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "./build"
    bin.install "bin/fleetctl"
  end

  test do
    system "#{bin}/fleetctl", "-version"
  end
end
