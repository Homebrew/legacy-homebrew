class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git", :tag => "0.7.0", :revision => "ab1b3727d723d34c15f890d0aa2844670cc4f3b8"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any
    sha256 "f39fc9f3e82b9ae7634550cf72a88775428d83045cd80d64f5668bbee97cb1a8" => :el_capitan
    sha256 "5f0a3ae96407d5306c8991ee5e8fd4f27b00833b2762570f9fdc452870b8a4aa" => :yosemite
  end

  depends_on :xcode => ["7.1", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    system "#{bin}/sourcekitten", "syntax", "--text", "import Foundation // Hello World"
  end
end
