class Multirust < Formula
  homepage "https://github.com/brson/multirust"
  desc "Manage multiple Rust installations"

  # Use the tag instead of the tarball to get submodules
  url "https://github.com/brson/multirust.git",
    :tag => "0.7.0",
    :revision => "b222fcd277898c7e364cbe7dfa0cf7edb5d922d5"

  head "https://github.com/brson/multirust.git"

  bottle do
    sha256 "a44637f895f33c6bc220ca9716055ebafadcef4d4d80e766e073d06a09ee008f" => :yosemite
    sha256 "ace5fdd7fa1088ce685dd3d05fb3c765d1fef19af3ecdae4264f35d8bd440f42" => :mavericks
    sha256 "fda4e8a56c51643e5b3edea4e714c311287e53038dfe7acf955776e6c881bf94" => :mountain_lion
  end

  depends_on :gpg => [:recommended, :run]

  def install
    system "./build.sh"
    system "./install.sh", "--prefix=#{prefix}"
  end

  test do
    system "#{bin}/multirust", "show-default"
  end
end
