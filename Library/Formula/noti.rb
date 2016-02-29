require "language/go"

class Noti < Formula
  desc "Displays a notification after a terminal process finishes."
  homepage "https://github.com/variadico/noti"
  url "https://github.com/variadico/noti/archive/v2.1.1.tar.gz"
  sha256 "c31c763eb92b4600371b2a62f6dc1dbb3390d89c09e0baab7af0dc427b55a8c5"
  head "https://github.com/variadico/noti.git", :branch => "dev"

  bottle do
    cellar :any_skip_relocation
    sha256 "73b2dd27dde106cc58565adb4ea19d497ca0037ed983800bff230605d19bf993" => :el_capitan
    sha256 "9e6614f1df36d6c6fecc515c6ca183f528a460f5c2a9ffb6ca9f1076542bfbda" => :yosemite
    sha256 "4d0fa419b3090f1196914180766c5af695e23d140d0b38b93ed12d8a1e52075a" => :mavericks
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
