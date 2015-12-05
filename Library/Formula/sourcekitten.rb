class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git", :tag => "0.6.2", :revision => "9b0f6ac3da6cd1df4075c03efa53a64fe6ba30e3"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any
    sha256 "ebe2bb2274fcabf35c3f5e54f1d421e40967bcac82ee9f70bac887f15c2360a8" => :el_capitan
    sha256 "8793cf4b4f3c40a07755067e021bc6321d21ae340f737850e696d960f71246bb" => :yosemite
  end

  depends_on :xcode => ["7.1", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    system "#{bin}/sourcekitten", "syntax", "--text", "import Foundation // Hello World"
  end
end
