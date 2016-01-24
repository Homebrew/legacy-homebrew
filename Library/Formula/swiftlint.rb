class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git", :tag => "0.7.0", :revision => "2241a1e4dfa93a5e9373493d4b6a72078d2bae2c"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "0c7a9da5dbc01af7378da5290494f3a5964cb61fbec3f4d536c89b5a104eb6e7" => :el_capitan
    sha256 "d1b2cde9f2609d7513790960d27c710262e2e4fb301406a1cef37d80852e64b1" => :yosemite
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
