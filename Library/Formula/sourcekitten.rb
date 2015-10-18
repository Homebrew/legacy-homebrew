class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git", :tag => "0.5.0", :revision => "4106ae36b4fc7a98406ed9bdd1d64074a04a35be"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any
    sha256 "22d194285569b9413e152cf2b71356d79975e5db632d2071f7ff174aa47af2a0" => :el_capitan
    sha256 "1265c3dcee58bb5fccb1d52acd842cfe533d20a99ffe7e5adbdd73a67419578d" => :yosemite
  end

  depends_on :xcode => ["7.0", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    system "#{bin}/sourcekitten", "syntax", "--text", "import Foundation // Hello World"
  end
end
