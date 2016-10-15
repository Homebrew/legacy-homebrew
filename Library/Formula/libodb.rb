class Libodb < Formula
  homepage "http://www.codesynthesis.com/products/odb/"
  url "http://www.codesynthesis.com/download/odb/2.4/libodb-2.4.0.tar.gz"
  sha256 "bfb9c398a6fdec675e33b320a1f80bdf74d8fbb700073bf17062f5b3ae1a2d5c"

  option "with-odb", "Install the ODB compiler"

  depends_on "gcc"
  depends_on "odb" => :optional

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
      #include <odb/exceptions.hxx>
      int main()
      {
        try {
          throw odb::null_pointer();
        } catch (const odb::null_pointer &e) {}
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-lodb"
    system "./test"
  end
end
