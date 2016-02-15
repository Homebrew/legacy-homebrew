class Dcadec < Formula
  desc "DTS Coherent Acoustics decoder with support for HD extensions"
  homepage "https://github.com/foo86/dcadec"
  url "https://github.com/foo86/dcadec.git",
    :tag => "v0.1.0",
    :revision => "2449e5d00ad32da3aed7cedfcec5bd475af9f678"
  head "https://github.com/foo86/dcadec.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3ddc040cb3f7ae162181a505ce6f6c633aa45beefb0bb8ad429bddfe02e2ce76" => :el_capitan
    sha256 "222fd874fe6cd6aba92c7a7fb46cd2f4c5f2fcf228bc6165a76e2731c16e4601" => :yosemite
    sha256 "97761971a8533704fa26e8f61465b13fff0afe387ea2270ccc8b1f38bc36699d" => :mavericks
  end

  resource "sample" do
    url "https://github.com/foo86/dcadec-samples/raw/fa7dcf8c98c6d/xll_71_24_96_768.dtshd"
    sha256 "d2911b34183f7379359cf914ee93228796894e0b0f0055e6ee5baefa4fd6a923"
  end

  def install
    system "make", "all"
    system "make", "check"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    resource("sample").stage do |r|
      system "#{bin}/dcadec", r.cached_download
    end
  end
end
