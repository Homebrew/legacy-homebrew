require "formula"

# dub generates version information from git, when building.
# To not break this, we provide a custom download strategy.
class DubHeadDownloadStrategy < GitDownloadStrategy
  def stage
    @clone.cd {reset}
    safe_system "git", "clone", @clone, "."
  end
end

class Dub < Formula
  homepage "http://code.dlang.org/about"
  url  "https://github.com/D-Programming-Language/dub/archive/v0.9.21.tar.gz"
  sha1 "7752e14f3f5add50b1c7d9138739d72b276e6abe"

  head "https://github.com/D-Programming-Language/dub.git", :using => DubHeadDownloadStrategy, :shallow => false

  devel do
    url "https://github.com/D-Programming-Language/dub/archive/v0.9.22-rc.1.tar.gz"
    sha1 "8ca2ac66675ce869cbf4930e989bb6fa41dc61b8"
  end

  depends_on "pkg-config" => :build
  depends_on "dmd"  => :build

  def install
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    system "#{bin}/dub; true"
  end
end
