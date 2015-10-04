class Stdman < Formula
  desc "Formatted C++11/14 stdlib man pages from cppreference.com"
  homepage "https://github.com/jeaye/stdman"
  url "https://github.com/jeaye/stdman/archive/v0.2.tar.gz"
  sha256 "9591835b0f57f88698d7c46ef645064a4af646644535cf2a052152656d73329a"

  bottle do
    cellar :any
    sha256 "bdafb5c1461c5166c682fa59617bc7d29c8c37eda3da862e5ce213a85fb08813" => :yosemite
    sha256 "a43224e47bc29cd6ddd3f18d53793bec65a44ac8107082bb492cfc49103ff22c" => :mavericks
    sha256 "b00742508c8b2dffe738114e606a887d189a8ed79653531b9f969e2e90a6d3d4" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "man", "-w", "std::string"
  end
end
