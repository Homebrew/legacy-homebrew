class Multirust < Formula
  homepage "https://github.com/brson/multirust"
  desc "Manage multiple Rust installations"

  # Use the tag instead of the tarball to get submodules
  url "https://github.com/brson/multirust.git",
    :tag => "0.8.0",
    :revision => "8654d1c07729e961c172425088c451509557ef32"

  head "https://github.com/brson/multirust.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6900a083146692e8d30fd94dbd969856bbee8186b945b328fa40068c5955c8cd" => :el_capitan
    sha256 "0abc281d9aaf174e12c31c04f2c68af246cb21f094d87d41ab901f25c301b5f1" => :yosemite
    sha256 "c7bd82c7f7efe53eb53a10aa97713f37913397d813e1637a1e21708dc41c57c3" => :mavericks
  end

  depends_on :gpg => [:recommended, :run]

  conflicts_with "rust", :because => "both install rustc, rustdoc, cargo, rust-lldb, rust-gdb"

  def install
    system "./build.sh"
    system "./install.sh", "--prefix=#{prefix}"
  end

  test do
    system "#{bin}/multirust", "show-default"
  end
end
