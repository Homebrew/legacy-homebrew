require "language/go"

class Noti < Formula
  desc "Displays a notification after a terminal process finishes."
  homepage "https://github.com/variadico/noti"
  url "https://github.com/variadico/noti/archive/v2.0.0.tar.gz"
  sha256 "55c788afb4bafb63509f2b6c974e2afd7a6a97d06653ddca9ea1e92b507c5d7c"
  head "https://github.com/variadico/noti.git", :branch => "dev"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2077219fba2537144a5d21793dcf683a0f6d2f7853dc4da4b26bf86251e699b" => :el_capitan
    sha256 "9ed2ded9bc99cf7f57cd10a9492dac20bb9408f00925ed4e6c7266077a63d33b" => :yosemite
    sha256 "86d478b13b5429106e923673b7bc010430eb160e9bc0375754b943b4c88ec5f9" => :mavericks
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
