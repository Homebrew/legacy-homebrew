class Swiftlint < Formula
  desc "Experimental tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git", :tag => "0.1.2", :revision => "4c91500e7b90a1d651d16e9c604ab927da050e8f"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "f73bae12ae6edf206e56c866775ca8347f809dc9130eab6ab3068acbde8a8b44" => :yosemite
  end

  depends_on :xcode => ["6.4", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SwiftLint.dst"
  end

  test do
    (testpath/"Test.swift").write "import Foundation\n"
    system "#{bin}/swiftlint"
  end
end
