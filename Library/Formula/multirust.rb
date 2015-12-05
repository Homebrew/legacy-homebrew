class Multirust < Formula
  homepage "https://github.com/brson/multirust"
  desc "Manage multiple Rust installations"

  # Use the tag instead of the tarball to get submodules
  url "https://github.com/brson/multirust.git",
    :tag => "0.7.0",
    :revision => "b222fcd277898c7e364cbe7dfa0cf7edb5d922d5"

  head "https://github.com/brson/multirust.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "835c85c711bc3df23da5eadb11eaaa715e3dba989cb32a52bd9ec37f1a33c7f3" => :el_capitan
    sha256 "a931aa36e3264b5b73a61171b8615428bd79dac7322c0dff5192140f9a340335" => :yosemite
    sha256 "14310f6110a75f9888a2ddb16be8371b1ad72601a1486984fdeaf8a673bc2f4a" => :mavericks
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
