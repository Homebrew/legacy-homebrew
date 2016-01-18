class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git", :tag => "0.7.4", :revision => "9b5c8d05813fb9e817f24ebe2142915f03132bf1"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any
    sha256 "c97a6eeaca66c30b023c90b2dde23c32ca0f1ce3b0829e6ac9fc2d5cdfca57c1" => :el_capitan
    sha256 "d0067e81e9da2fcbe80e048fe7d7d38ffa01401f30ad063f2394863c35ec7a6a" => :yosemite
  end

  depends_on :xcode => ["7.1", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    system "#{bin}/sourcekitten", "syntax", "--text", "import Foundation // Hello World"
  end
end
