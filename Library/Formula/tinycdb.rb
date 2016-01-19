class Tinycdb < Formula
  desc "Create and read constant databases"
  homepage "http://www.corpit.ru/mjt/tinycdb.html"
  url "http://www.corpit.ru/mjt/tinycdb/tinycdb-0.78.tar.gz"
  sha256 "50678f432d8ada8d69f728ec11c3140e151813a7847cf30a62d86f3a720ed63c"

  bottle do
    cellar :any
    sha256 "d73abbd1439c1579c3ab925d2110fee60f287bb9b262850e030c74f7c356bcaa" => :yosemite
    sha256 "b35dda3e5219c993140f7ed6244f483b0159cbd4458fb3ee4461e25daa368d41" => :mavericks
    sha256 "cc08f9c7d8ab18de0f547d6790ebef51ad0984e82ed99e8d2cb7567725ca8eb5" => :mountain_lion
  end

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}", "mandir=#{man}"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <fcntl.h>
      #include <cdb.h>

      int main() {
        struct cdb_make cdbm;
        int fd;
        char *key = "test",
             *val = "homebrew";
        unsigned klen = 4,
                 vlen = 8;

        fd = open("#{testpath}/db", O_RDWR|O_CREAT);

        cdb_make_start(&cdbm, fd);
        cdb_make_add(&cdbm, key, klen, val, vlen);
        cdb_make_exists(&cdbm, key, klen);
        cdb_make_finish(&cdbm);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lcdb", "-o", "test"
    system "./test"
  end
end
