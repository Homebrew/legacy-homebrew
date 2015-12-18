class Swiftlint < Formula
  desc "Experimental tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git", :tag => "0.5.2", :revision => "eab6bf50755c7778252f1363e977546949d6983d"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "06b03ecb315af8ae0504c599e27e4ffd476b1fdea93335ccb7b0ff19cf1c55d0" => :el_capitan
    sha256 "24cd77802aa30c26fa08ff8a8fe3b2a956a315804a611dc548290c8a3de0cc7f" => :yosemite
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
