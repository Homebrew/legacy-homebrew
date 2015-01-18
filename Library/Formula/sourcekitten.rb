class Sourcekitten < Formula
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git", :tag => "0.3.1"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any
    sha1 "0c2eeaebca3d1e193ff097153d9f8d2afb307964" => :yosemite
    sha1 "f55c779524fb1dc74554e8e2592d402198bbc55d" => :mavericks
  end

  depends_on :xcode => ["6.1.1", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    system "#{bin}/sourcekitten", "syntax", "--text", "import Foundation // Hello World"
  end
end
