class Norm < Formula
  desc "NACK-Oriented Reliable Multicast"
  homepage "https://www.nrl.navy.mil/itd/ncs/products/norm"
  url "https://downloads.pf.itd.nrl.navy.mil/norm/archive/src-norm-1.5r6.tgz"
  version "1.5r6"
  sha256 "20ea2e8dd5d5e1ff1ff91dc7dab6db53a77d7b7183d8cf2425c215fd294f22a7"

  bottle do
    cellar :any
    sha256 "2c165178bfce5879bb6e031b4d54f741cad2868d67b03783f89a13d15503f28d" => :yosemite
    sha256 "b5f802ff09e68b712f472f45aea9b634f6c45868bccaf708d565ff98a95b145e" => :mavericks
    sha256 "e04bed5670762178e4415296b95829b9e3c75da265f9375c6c6efac310b7b3d4" => :mountain_lion
  end

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "install"
    include.install "include/normApi.h"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <assert.h>
      #include <normApi.h>

      int main()
      {
        NormInstanceHandle i;
        i = NormCreateInstance(false);
        assert(i != NORM_INSTANCE_INVALID);
        NormDestroyInstance(i);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lnorm", "-o", "test"
    system "./test"
  end
end
