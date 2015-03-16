class LibodbSqlite < Formula
  homepage "http://www.codesynthesis.com/products/odb/"
  url "http://www.codesynthesis.com/download/odb/2.4/libodb-sqlite-2.4.0.tar.gz"
  sha256 "cd687c882a8dc14ded4eb160e82de57e476b1feef5c559c5a6a5c7e671a10cf4"

  depends_on "libodb"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "CXX=#{ENV.cxx} -stdlib=libstdc++",
                          "LIBS=-lstdc++"
    system "make", "install"

    opoo "libodb must be built with the same compiler your executable will be.
This packages is compiled with \"#{ENV.cxx}\", so we assume your app will also be."
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <odb/sqlite/exceptions.hxx>
      int main()
      {
        try {
          throw odb::sqlite::forced_rollback();
        } catch (const odb::sqlite::forced_rollback &e) {}
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-lodb-sqlite", "-lodb"
    system "./test"
  end
end
