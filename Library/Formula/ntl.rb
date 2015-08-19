class Ntl < Formula
  desc "C++ number theory library"
  homepage "http://www.shoup.net/ntl"
  url "http://www.shoup.net/ntl/ntl-9.3.0.tar.gz"
  sha256 "8f31508a9176b3fc843f08468b1632017f2450677bfd5147ead5136e0f24b68f"

  bottle do
    cellar :any
    sha256 "caa258ebeb39f602cef0627b3f3391136a79bd1ce9d81bc727f104a6e65f8feb" => :yosemite
    sha256 "92fa4146b889fd7a0b4dd50aed248cfe310fb3e7cb3b65d608aca26298331b46" => :mavericks
    sha256 "dd1f71b5dd429df7cc7254a2b5c99ceb844ad2ba8cdc4e258fb22db4ccf68ec3" => :mountain_lion
  end

  depends_on "gmp" => :optional

  def install
    args = ["PREFIX=#{prefix}"]
    args << "NTL_GMP_LIP=on" if build.with? "gmp"

    cd "src" do
      system "./configure", *args
      system "make"
      system "make", "check"
      system "make", "install"
    end
  end
end
