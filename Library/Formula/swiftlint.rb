class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git", :tag => "0.9.1", :revision => "0d6ed5c71e7eafdb5f7a7cdecf9f3ae09e404ee3"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "0c45ac369343bbd3338cf6ce2b06605591e1e98f7ecf057d4eb0f79839e5cf10" => :el_capitan
    sha256 "f957248a16a16e356b5b5edb9dde2b1b4246c9432e6a34138139e82ae598103a" => :yosemite
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
