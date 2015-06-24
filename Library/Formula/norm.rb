class Norm < Formula
  desc "NACK-Oriented Reliable Multicast"
  homepage "https://www.nrl.navy.mil/itd/ncs/products/norm"
  url "https://downloads.pf.itd.nrl.navy.mil/norm/archive/src-norm-1.5b3.tgz"
  sha256 "ec2014f57be12ea3ade0685faa1e6e161f168311c8975093bce33a6e1dc5e77c"

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
