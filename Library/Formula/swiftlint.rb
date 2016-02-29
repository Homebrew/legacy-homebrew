class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git", :tag => "0.9.1", :revision => "0d6ed5c71e7eafdb5f7a7cdecf9f3ae09e404ee3"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "21f41f5af59c03332adfcfb64993f375d13937950b1f5aadbeb2b83dc60668b7" => :el_capitan
    sha256 "ccaa8a459d3da2ff3da10449a06035627588a7bc430e655b2593428933836331" => :yosemite
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
