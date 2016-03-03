class Omniorb < Formula
  desc "IOR and naming service utilities for omniORB"
  homepage "http://omniorb.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.2.1/omniORB-4.2.1-2.tar.bz2"
  sha256 "9b638c7047a05551c42fe13901194e63b58750d4124654bfa26203d09cb5072d"

  bottle do
    sha256 "8575f53c6de3426c4f640c97fbc966b220869dada8e636494f4a1fe5c1769990" => :yosemite
    sha256 "2245722bc7b21cecee0bfc4b145d3bab51d79979bfbf9e6cb1a0211b4c166e85" => :mavericks
    sha256 "0a5e41a4e19fbe4d685822b2da354d8dd9f5bd32e02376d74d7dfed9e9b9f767" => :mountain_lion
  end

  depends_on "pkg-config" => :build

  resource "bindings" do
    url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.2.1/omniORBpy-4.2.1-2.tar.bz2"
    sha256 "e0d0f89c0fc6e33b480a2bf7acc7d353b9346a7067571a6be8f594c78b161422"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    resource("bindings").stage do
      system "./configure", "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/omniidl", "-h"
  end
end

