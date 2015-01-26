class Libodb < Formula
  homepage "http://www.codesynthesis.com/products/odb"
  url "http://www.codesynthesis.com/download/odb/2.3/libodb-2.3.0.tar.bz2"
  sha1 "eebc7fa706bc598a80439d1d6a798430fcfde23b"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"main.cxx").write <<-EOS.undent
    #include <odb/core.hxx>
    int main()
    {
      return 0;
    }
    EOS

    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lodb", "main.cxx", "-o", "test"
    system "./test"
  end
end
