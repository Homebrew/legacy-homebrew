class Pbc < Formula
  desc "Pairing-based cryptography"
  homepage "https://crypto.stanford.edu/pbc/"
  url "https://crypto.stanford.edu/pbc/files/pbc-0.5.14.tar.gz"
  sha256 "772527404117587560080241cedaf441e5cac3269009cdde4c588a1dce4c23d2"
  head "http://repo.or.cz/r/pbc.git"

  bottle do
    cellar :any
    sha1 "57180c03e2d82474c205d60783f5c657de8f5bd5" => :yosemite
    sha1 "9519b2e974ff93fb7e33ff776c008a3a0083d70b" => :mavericks
    sha1 "2a3e05bc353b12436aad2ad6fdd67224651e6e44" => :mountain_lion
  end

  depends_on "gmp"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <pbc/pbc.h>
      #include <assert.h>

      int main()
      {
        pbc_param_t param;
        pairing_t pairing;
        element_t g1, g2, gt1, gt2, gt3, a, g1a;
        pbc_param_init_a_gen(param, 160, 512);
        pairing_init_pbc_param(pairing, param);
        element_init_G1(g1, pairing);
        element_init_G2(g2, pairing);
        element_init_G1(g1a, pairing);
        element_init_GT(gt1, pairing);
        element_init_GT(gt2, pairing);
        element_init_GT(gt3, pairing);
        element_init_Zr(a, pairing);
        element_random(g1); element_random(g2); element_random(a);
        element_pairing(gt1, g1, g2); // gt1 = e(g1, g2)
        element_pow_zn(g1a, g1, a); // g1a = g1^a
        element_pow_zn(gt2, gt1, a); // gt2 = gt1^a = e(g1, g2)^a
        element_pairing(gt3, g1a, g2); // gt3 = e(g1a, g2) = e(g1^a, g2)
        assert(element_cmp(gt2, gt3) == 0); // assert gt2 == gt3
        pairing_clear(pairing);
        element_clear(g1); element_clear(g2); element_clear(gt1);
        element_clear(gt2); element_clear(gt3); element_clear(a);
        element_clear(g1a);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lgmp", "-lpbc", "-o", "test"
    system "./test"
  end
end
