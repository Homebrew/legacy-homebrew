class Swiftlint < Formula
  desc "Experimental tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git", :tag => "0.5.4", :revision => "4421657de5ef66b3f3de4c1c2bc7f72b9b5072d0"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "e19a4b5685dc257af73cd9d7ffa8de5c2da4633d9b71466bfa17792b74f82562" => :el_capitan
    sha256 "8cc15dc59191db3773563f2a4d0ebb92c0bfe257f3fc5e83b15b28cde1c1f2bb" => :yosemite
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
