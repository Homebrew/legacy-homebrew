class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git", :tag => "0.11.0", :revision => "6415bc91fde389c9b4866e2b61e1189be4c9796c"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any
    sha256 "5b523457b74070712f7b1c091d9f178cc3b5bbe17dbacff40ea7bf75e6dc0c9a" => :el_capitan
    sha256 "e0f67f647ffcf557b597c1a5656846fd5738d359877faf0d97d8a1b9d6ef8503" => :yosemite
  end

  depends_on :xcode => ["7.1", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    system "#{bin}/sourcekitten", "syntax", "--text", "import Foundation // Hello World"
  end
end
