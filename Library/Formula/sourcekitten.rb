class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git", :tag => "0.9.0", :revision => "fe838df11c6fd9337320ae47bf12351b88c968d1"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any
    sha256 "0a9b3daeb44a25a63c42764292220278c83ea90ded9a6a86847d8fbecab0a129" => :el_capitan
    sha256 "24756b9af28b2b764be3a90cc80f4351fc7ab703b9091e80ad27cf5309dae065" => :yosemite
  end

  depends_on :xcode => ["7.1", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    system "#{bin}/sourcekitten", "syntax", "--text", "import Foundation // Hello World"
  end
end
