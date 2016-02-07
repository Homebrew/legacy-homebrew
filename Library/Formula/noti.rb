require "language/go"

class Noti < Formula
  desc "Displays a notification after a terminal process finishes."
  homepage "https://github.com/variadico/noti"
  url "https://github.com/variadico/noti/archive/v1.3.0.tar.gz"
  sha256 "78ffba8f6d8cb27df06a7c1ebe9d58cf605175c056eca1be241a5f348a117b8f"
  head "https://github.com/variadico/noti.git", :branch => "dev"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d892998f3bbed1ba19b9e6a1dfe00094d0123cecfa058e608538e05a38524e6" => :el_capitan
    sha256 "0aaa37cb4cfde091dce33a9a883f1dc2c1f27756400acdc84198c418c8cb2c4c" => :yosemite
    sha256 "2cef02d159190232c99658be80e397e6f70e78e2e80a71685c710e920afa6c40" => :mavericks
  end

  devel do
    url "https://github.com/variadico/noti/archive/v2.0.0-rc.1.tar.gz"
    sha256 "5ac154855f05ed60c05642030d4f66f9665e51b7032fc57e999c81160dcdf611"
    version "2.0.0-rc.1"
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
