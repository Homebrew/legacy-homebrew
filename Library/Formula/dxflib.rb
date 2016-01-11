class Dxflib < Formula
  desc "C++ library for parsing DXF files"
  homepage "https://www.ribbonsoft.com/en/what-is-dxflib"
  url "https://www.ribbonsoft.com/archives/dxflib/dxflib-2.5.0.0-1.src.tar.gz"
  sha256 "20ad9991eec6b0f7a3cc7c500c044481a32110cdc01b65efa7b20d5ff9caefa9"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "aff6c3f5e5bca552c5962e8ef5c43d1dd5fb0630d091e206a164e99ed8b70637" => :el_capitan
    sha256 "e883aa60c9baab1198671db178c0723e4331ed9fb65ad4d87ba72ca921d7d0b4" => :yosemite
    sha256 "0e591fba7cac298bf4afbb4d7f9895c10865998c6ae64ad4db31c7a33c3377cc" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
