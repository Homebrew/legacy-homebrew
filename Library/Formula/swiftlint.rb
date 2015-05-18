class Swiftlint < Formula
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git", :tag => "0.1.0", :revision => "ed7eadd5c6011c35d017290fb7fb55e735dc18ba"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "1d6c4631e894635fbbbb6d006e5e186452cf40ea0e2e5d98442dda2bda6efd20" => :yosemite
  end

  depends_on :xcode => ["6.3", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SwiftLint.dst"
  end

  test do
    (testpath/"Test.swift").write "import Foundation\n"
    system "#{bin}/swiftlint"
  end
end
