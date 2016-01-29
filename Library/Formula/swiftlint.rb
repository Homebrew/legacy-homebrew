class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git", :tag => "0.7.2", :revision => "19df2a9fba6453424b375616c499be3ad5a66597"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "18169471f92bfc8eed1f2a63f7ff2aa4b7edf3051ee21c5ff3983c9d2c226e68" => :el_capitan
    sha256 "7348f1602f5acd85068cbd40fa279e11c6b24ec346fb5ab2df2183950521c3b9" => :yosemite
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
