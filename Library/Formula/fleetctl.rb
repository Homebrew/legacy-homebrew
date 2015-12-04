class Fleetctl < Formula
  desc "Distributed init system"
  homepage "https://github.com/coreos/fleet"
  url "https://github.com/coreos/fleet/archive/v0.11.5.tar.gz"
  sha256 "a6a785099df71645b5fe8755a36baa6c11138749bc02ae4990fd3f52663c0394"
  head "https://github.com/coreos/fleet.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e7e397b224aeed84bae981f349776f1cfaad1ac2d5b8cb6ae5c8b1f59d033aa" => :el_capitan
    sha256 "66d1adc5c8b70ea5e28b0f7bd7a73f0baeb557198e90cc3a0bb87733524d5350" => :yosemite
    sha256 "b444e18c6ad84389b3c7056ed190b22cf3427d77bc77323e30615d5794649e6e" => :mavericks
    sha256 "0c48461c277d601a0abff0ff43110618316abd5bcbd498538a791ad91b5ce71d" => :mountain_lion
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
