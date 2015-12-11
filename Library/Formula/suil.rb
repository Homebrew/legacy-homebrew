class Suil < Formula
  desc "lightweight C library for loading and wrapping LV2 plugin UIs"
  homepage "http://drobilla.net/software/suil/"
  url "http://download.drobilla.net/suil-0.8.2.tar.bz2"
  sha256 "787608c1e5b1f5051137dbf77c671266088583515af152b77b45e9c3a36f6ae8"

  depends_on "lv2"
  depends_on "qt" => :optional
  depends_on "qt5" => :optional
  depends_on "gtk+" => :recommended
  depends_on "pkg-config" => :build
  depends_on :x11 => :optional

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <suil/suil.h>

      int main()
      {
        return suil_ui_supported("my-host", "my-ui");
      }
    EOS
    system ENV.cc, "-I#{include}/suil-0", "-L#{lib}", "-lsuil-0", "test.c", "-o", "test"
    system "./test"
  end
end
