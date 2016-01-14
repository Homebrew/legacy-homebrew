class Swiftlint < Formula
  desc "Experimental tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git", :tag => "0.5.6", :revision => "cff056bf0de16d934b3657807f7c4cb4d69dfd21"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "7c20de6100924cfc93b5275abb3db522aaca401095d0eb73a15478c49d1e0454" => :el_capitan
    sha256 "f9fa5f5e1ef845bf3967539d7d9fbd930fb734c7e16c50edf23d3c7e75e5a37b" => :yosemite
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
