class Swiftlint < Formula
  desc "Experimental tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git", :tag => "0.4.0", :revision => "1201a9e38cddb842aee7ad8ae48078e1d722f39f"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "ffe867b5dbfac006d0d28b70dcda2c9e839ecac99412738bbea29e661dafc447" => :el_capitan
    sha256 "3eb2a1380f6f2684228bb2836c250db56ef29cea661356a73898fedc3d725fb7" => :yosemite
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
