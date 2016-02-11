class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git", :tag => "0.8.0", :revision => "3d86029f718b2588ba5a204857165fc5a685774f"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "22800f0123ef757b1084b6c42fd9f5be59a4b5f41ece146d50ab43ac08aa5229" => :el_capitan
    sha256 "69cafc1bc66d33fc066d734f75d7c13c4d784da4bde5239ed312bd87460cd74d" => :yosemite
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
