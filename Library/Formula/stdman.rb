class Stdman < Formula
  desc "Formatted C++11/14 stdlib man pages from cppreference.com"
  homepage "https://github.com/jeaye/stdman"
  url "https://github.com/jeaye/stdman/archive/v0.2.tar.gz"
  sha256 "9591835b0f57f88698d7c46ef645064a4af646644535cf2a052152656d73329a"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
