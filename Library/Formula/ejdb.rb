class Ejdb < Formula
  desc "C library based on modified version of Tokyo Cabinet"
  homepage "http://ejdb.org"
  url "https://github.com/Softmotions/ejdb/archive/v1.2.10.tar.gz"
  sha256 "3a6d4a487e02c05dd67e72a77ee6082fbb1f5a19d4f7f15d14e1c891bbfe520e"

  head "https://github.com/Softmotions/ejdb.git"

  bottle do
    cellar :any
    sha256 "15c0f59354c39a9481591bbfad7e46f8c87cfeda8371e27728009b0fc20fc923" => :yosemite
    sha256 "4afc62e8452bc92ebd72c89b134b16f5d9781f56eee2b7b75e1ab03698ca5fc7" => :mavericks
    sha256 "246e34413c364ce13accac4c23169ebf42daaba94f1aa90c770fafd6aa74a6b0" => :mountain_lion
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
