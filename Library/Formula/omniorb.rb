class Omniorb < Formula
  desc "IOR and naming service utilities for omniORB"
  homepage "http://omniorb.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.2.1/omniORB-4.2.1-2.tar.bz2"
  sha256 "9b638c7047a05551c42fe13901194e63b58750d4124654bfa26203d09cb5072d"

  bottle do
    sha256 "f433740ab82239c1e634f77c90a7657d540df7bcecb8666461b38584e25f76db" => :el_capitan
    sha256 "a7ec7b6c556d1fa1fa447e07cfddbe30e0c6a0936637c554c43d5162baf8e3af" => :yosemite
    sha256 "6fdf2acaf82b96459db16f272b97ac8a7ac4088227a2dcfb69331d3b7f672568" => :mavericks
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

