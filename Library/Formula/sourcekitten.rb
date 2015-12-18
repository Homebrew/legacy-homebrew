class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git", :tag => "0.7.2", :revision => "53a1f2ea1dd4481fdcc816af4b682c4e71ac17b9"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any
    sha256 "63f7b5e1c2b89c3d13e95c7e668cacf6df5007bf9220141ce7cf8d5a0ff4cbb8" => :el_capitan
    sha256 "89d81708a6d0b41d03aaaabc3501ca8c756fa9ab7e777317ae2dd10752ee25ee" => :yosemite
  end

  depends_on :xcode => ["7.1", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    system "#{bin}/sourcekitten", "syntax", "--text", "import Foundation // Hello World"
  end
end
