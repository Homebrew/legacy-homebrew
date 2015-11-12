class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git", :tag => "0.6.0", :revision => "1906127b7fc2c4dfa2d441b0f63ee9be05b25e1a"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any
    sha256 "a1bda51cd5fcc241ed4a958a4ed7b1e129cb8db6bf294efc830053ccf28d51ba" => :el_capitan
    sha256 "090611bbba3692940e2cc9f951985fba7991e7b19edbff96834138e4ac77b1a5" => :yosemite
  end

  depends_on :xcode => ["7.1", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    system "#{bin}/sourcekitten", "syntax", "--text", "import Foundation // Hello World"
  end
end
