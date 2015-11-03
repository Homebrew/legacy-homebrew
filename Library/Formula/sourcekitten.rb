class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git", :tag => "0.5.2", :revision => "7b951bc70f130d13da734ca9b2bba581ebbd7463"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any
    sha256 "7ce9a9b33215f8d237f9e06a9e2b8b5f4412155789691ffd789a94d39c232c88" => :el_capitan
    sha256 "d450a5f877b60333b8d6dc6c7fbedb15fbddb68180a4dcc999c8f82f46ca8759" => :yosemite
  end

  depends_on :xcode => ["7.1", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    system "#{bin}/sourcekitten", "syntax", "--text", "import Foundation // Hello World"
  end
end
