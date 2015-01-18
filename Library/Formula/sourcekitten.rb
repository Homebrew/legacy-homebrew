class Sourcekitten < Formula
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git", :tag => "0.3.1"
  head "https://github.com/jpsim/SourceKitten.git"

  depends_on :xcode => ["6.1.1", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    system "#{bin}/sourcekitten", "syntax", "--text", "import Foundation // Hello World"
  end
end
