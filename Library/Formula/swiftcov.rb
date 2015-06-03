class Swiftcov < Formula
  homepage "https://github.com/realm/SwiftCov"
  url "https://github.com/realm/SwiftCov.git", :tag => "0.1.0", :revision => "3a13f0ede4449fd3e4e07878031544d906ee19f9"
  head "https://github.com/realm/SwiftCov.git"

  depends_on :xcode => ["6.3", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SwiftCov.dst"
  end

  test do
    system "#{bin}/swiftcov help"
  end
end
