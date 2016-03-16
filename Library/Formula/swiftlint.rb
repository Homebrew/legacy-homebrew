class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git", :tag => "0.9.2", :revision => "6cafa08e70dab64c39c38ea5b9542126389d27aa"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "3efa117e8506cec1eee8dacaccf6bc86e009d189502a07fb265064390cb7af69" => :el_capitan
    sha256 "dc70240351452d4a9fe8b46030b7d4e4db93c005445a5b712956515fafa5ec88" => :yosemite
  end

  depends_on :xcode => ["7.1", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SwiftLint.dst"
  end

  test do
    (testpath/"Test.swift").write "import Foundation\n"
    system "#{bin}/swiftlint"
  end
end
