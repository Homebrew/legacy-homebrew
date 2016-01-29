class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git", :tag => "0.7.2", :revision => "19df2a9fba6453424b375616c499be3ad5a66597"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "cf001822d97c21eb2ec0e67a87e6f4be72abf50ac3fb65cd9c916c95b3c9d04a" => :el_capitan
    sha256 "f4a7e08f13b66d7f3bb3c2c270d122a93ed09b82c3aa29a1ad02b1cd5e4fa972" => :yosemite
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
