class Sourcekitten < Formula
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git", :tag => "0.4.3", :revision => "d3dd7c76ca17b8e43165588a61bd65772e67cdac"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any
    sha256 "49e11e2ba849579a4636c41da1e104efb5d3fcfc3a8cee2fac95e4886f7520e4" => :yosemite
  end

  depends_on :xcode => ["6.3", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    system "#{bin}/sourcekitten", "syntax", "--text", "import Foundation // Hello World"
  end
end
