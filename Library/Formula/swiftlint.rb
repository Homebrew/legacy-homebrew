class Swiftlint < Formula
  desc "Experimental tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git", :tag => "0.4.0", :revision => "1201a9e38cddb842aee7ad8ae48078e1d722f39f"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "a83305980c00bcff6a7288bc358474010c58688c4da329b6c9c9ad6394b0115f" => :el_capitan
    sha256 "c840a54627913867c380cc7f0ebd794f3b56910c76fee4c050b359af6f1e027c" => :yosemite
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
