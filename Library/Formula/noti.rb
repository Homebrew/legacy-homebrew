require "language/go"

class Noti < Formula
  desc "Displays a notification after a terminal process finishes."
  homepage "https://github.com/variadico/noti"
  url "https://github.com/variadico/noti/archive/v2.1.1.tar.gz"
  sha256 "c31c763eb92b4600371b2a62f6dc1dbb3390d89c09e0baab7af0dc427b55a8c5"
  head "https://github.com/variadico/noti.git", :branch => "dev"

  bottle do
    cellar :any_skip_relocation
    sha256 "d35a463a362591ce41b9e609071ed876ffaa5c9540f2393a2e6bc0a20f97eea8" => :el_capitan
    sha256 "f5cc202358c1a7409b66ec9b3b3b411fbe2b9caccbd7746ec20beb70afdfc238" => :yosemite
    sha256 "5d655704e9f39feba5b6cf26a74be4a4dcf3bf337d18d0c0652ff4bfa2693012" => :mavericks
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
