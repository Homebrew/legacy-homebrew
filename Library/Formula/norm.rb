class Norm < Formula
  desc "NACK-Oriented Reliable Multicast"
  homepage "https://www.nrl.navy.mil/itd/ncs/products/norm"
  url "https://downloads.pf.itd.nrl.navy.mil/norm/archive/src-norm-1.5b3.tgz"
  sha256 "ec2014f57be12ea3ade0685faa1e6e161f168311c8975093bce33a6e1dc5e77c"

  bottle do
    cellar :any
    sha256 "eeb502e10f6407499c78292b29177c49f0723bf5ea5d199b11ce4aad4ed2be6f" => :yosemite
    sha256 "973ac3cfc7ee43dfddfbfb4cd967ceb833ba35d4b29c09db716883c02be176a7" => :mavericks
    sha256 "d8449b294d71b3fbba503c2ef1f3399f85dc5e1aad7fbf6f5b0209ca2e5a80e6" => :mountain_lion
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
