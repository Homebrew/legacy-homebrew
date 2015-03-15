class Libcutl < Formula
  homepage "http://www.codesynthesis.com/projects/libcutl/"
  url "http://www.codesynthesis.com/download/libcutl/1.9/libcutl-1.9.0.tar.gz"
  sha256 "1b575aa8ed74aa36adc0f755ae9859c6e48166a60779a5564dd21b8cb05afb7d"

  depends_on "gcc"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "CXX=#{ENV.cxx} -stdlib=libstdc++",
                          "LIBS=-lstdc++"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <cutl/exception.hxx>
      int main()
      {
        try {
          throw cutl::exception();
        } catch (const cutl::exception &e) {}
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-lcutl"
  end
end
