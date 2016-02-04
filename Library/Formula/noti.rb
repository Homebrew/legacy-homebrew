require "language/go"

class Noti < Formula
  desc "Displays a notification after a terminal process finishes."
  homepage "https://github.com/variadico/noti"
  url "https://github.com/variadico/noti/archive/v2.0.0.tar.gz"
  sha256 "55c788afb4bafb63509f2b6c974e2afd7a6a97d06653ddca9ea1e92b507c5d7c"
  head "https://github.com/variadico/noti.git", :branch => "dev"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d892998f3bbed1ba19b9e6a1dfe00094d0123cecfa058e608538e05a38524e6" => :el_capitan
    sha256 "0aaa37cb4cfde091dce33a9a883f1dc2c1f27756400acdc84198c418c8cb2c4c" => :yosemite
    sha256 "2cef02d159190232c99658be80e397e6f70e78e2e80a71685c710e920afa6c40" => :mavericks
  end

  depends_on "go" => :build

  def install
    mkdir_p "#{buildpath}/src/github.com/variadico"
    ln_s buildpath, "#{buildpath}/src/github.com/variadico/noti"
    ENV["GOPATH"] = buildpath
    cd "#{buildpath}/src/github.com/variadico/noti" do
      if build.stable?
        system "go", "build", "-o", "#{bin}/noti"
      else
        system "go", "build", "-o", "#{bin}/noti", "cmd/noti/main.go", "cmd/noti/osx.go"
      end
    end
  end

  test do
    system "#{bin}/noti", "-t", "Noti", "-m", "'Noti recipe installation test has finished.'"
  end
end
