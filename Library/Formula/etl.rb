class Etl < Formula
  desc "Extensible Template Library"
  homepage "http://synfig.org"
  url "https://downloads.sourceforge.net/project/synfig/releases/1.0/source/ETL-0.04.18.tar.gz"
  sha256 "53953e477a37d2e870e3be4b22f519474c24537b0e6eb1633e3402273a684a98"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <ETL/misc>
      int main(int argc, char *argv[])
      {
        int rv = etl::ceil_to_int(5.5);
        return 6 - rv;
      }
    EOS
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{include}
      -lpthread
    ]
    system ENV.cxx, "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
