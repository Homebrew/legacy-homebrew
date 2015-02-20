class Libghthash < Formula
  homepage "http://www.bth.se/people/ska/sim_home/libghthash.html"
  url "http://www.bth.se/people/ska/sim_home/filer/libghthash-0.6.2.tar.gz"
  sha1 "436146998c30a31b83adf4f58d978fccd78f2ba5"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    doc.install Dir["#{lib}/*[^.a]"]
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <ght_hash_table.h>

        int main() {
            ght_hash_table_t* table = ght_create(1);
            ght_finalize(table);
            return 0;
        }
      EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lghthash", "-o", "test"
    system "./test"
  end
end
