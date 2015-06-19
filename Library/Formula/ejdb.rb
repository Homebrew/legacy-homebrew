class Ejdb < Formula
  desc "C library based on modified version of Tokyo Cabinet"
  homepage "http://ejdb.org"
  url "https://github.com/Softmotions/ejdb/archive/v1.2.6.tar.gz"
  sha256 "50baee93b2815c1b9c45973eda4a03e36fabd1bc6987122dd391f16e43c88a9d"

  head "https://github.com/Softmotions/ejdb.git"

  bottle do
    cellar :any
    sha256 "e6eed78d9a3c3b87f78f7f27599e66642d6403c79a7880649eb1da62dfd2f27c" => :yosemite
    sha256 "c262565e0fb217c13147c3112d9450686af22de2516740ba70e3acf199a72ae5" => :mavericks
    sha256 "284b9c2230b10a825d282febd68dcc2a2604a8759b2f0266033422ef071497b9" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <ejdb/ejdb.h>

      static EJDB *jb;
      int main() {
          jb = ejdbnew();
          if (!ejdbopen(jb, "addressbook", JBOWRITER | JBOCREAT | JBOTRUNC)) {
              return 1;
          }
          EJCOLL *coll = ejdbcreatecoll(jb, "contacts", NULL);

          bson bsrec;
          bson_oid_t oid;

          bson_init(&bsrec);
          bson_append_string(&bsrec, "name", "Bruce");
          bson_append_string(&bsrec, "phone", "333-222-333");
          bson_append_int(&bsrec, "age", 58);
          bson_finish(&bsrec);

          ejdbsavebson(coll, &bsrec, &oid);
          bson_destroy(&bsrec);

          bson bq1;
          bson_init_as_query(&bq1);
          bson_append_start_object(&bq1, "name");
          bson_append_string(&bq1, "$begin", "Bru");
          bson_append_finish_object(&bq1);
          bson_finish(&bq1);

          EJQ *q1 = ejdbcreatequery(jb, &bq1, NULL, 0, NULL);

          uint32_t count;
          TCLIST *res = ejdbqryexecute(coll, q1, &count, 0, NULL);

          for (int i = 0; i < TCLISTNUM(res); ++i) {
              void *bsdata = TCLISTVALPTR(res, i);
              bson_print_raw(bsdata, 0);
          }
          tclistdel(res);

          ejdbquerydel(q1);
          bson_destroy(&bq1);

          ejdbclose(jb);
          ejdbdel(jb);
          return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lejdb",
           "test.c", "-o", testpath/"test"
    system "./test"
  end
end
