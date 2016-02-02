class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git", :tag => "0.9.0", :revision => "fe838df11c6fd9337320ae47bf12351b88c968d1"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any
    sha256 "101bf2bb7edebce880884018d6f953667bbfc94b46c665b337bfeb20cbbdb55e" => :el_capitan
    sha256 "03b8d06a401bd9403ca4e9d321d59ea8cf3354668e6dd9b7bee6f3d5e96a9c84" => :yosemite
  end

  depends_on :xcode => ["7.1", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    system "#{bin}/sourcekitten", "syntax", "--text", "import Foundation // Hello World"
  end
end
