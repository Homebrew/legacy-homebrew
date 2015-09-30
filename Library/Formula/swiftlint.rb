class Swiftlint < Formula
  desc "Experimental tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git", :tag => "0.2.0", :revision => "a71c9fbf015405de3ae2a92d051876074cfbf4ec"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "f73bae12ae6edf206e56c866775ca8347f809dc9130eab6ab3068acbde8a8b44" => :yosemite
  end

  depends_on :xcode => ["7.0", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SwiftLint.dst"
  end

  test do
    (testpath/"Test.swift").write "import Foundation\n"
    system "#{bin}/swiftlint"
  end
end
