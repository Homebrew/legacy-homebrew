class OpenVcdiff < Formula
  homepage "https://code.google.com/p/open-vcdiff/"
  url "https://drive.google.com/uc?id=0B5WpIi2fQU1aNGJwVE9hUjU5clU&export=download"
  version "0.8.4"
  sha256 "2b142b1027fb0a62c41347600e01a53fa274dad15445a7da48083c830c3138b3"

  def install
    system "./configure", "CPPFLAGS=-DGTEST_USE_OWN_TR1_TUPLE=1",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS
      #include <google/vcdecoder.h>
      int main()
      {
        open_vcdiff::VCDiffDecoder decoder;
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lvcddec", "-lvcdcom",
           testpath/"test.cpp", "-o", "test"
    system "./test"
  end
end
