class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git", :tag => "0.7.4", :revision => "9b5c8d05813fb9e817f24ebe2142915f03132bf1"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any
    sha256 "67e3c77385f093dfb7c10e212bbd618c4a5ebcf5ec429605459f7f65289b6c7a" => :el_capitan
    sha256 "57d53d1976e0fe8c3189f510f6234a424be610833031de9af06a3d523b6e673f" => :yosemite
  end

  depends_on :xcode => ["7.1", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    system "#{bin}/sourcekitten", "syntax", "--text", "import Foundation // Hello World"
  end
end
