class Suil < Formula
  desc "lightweight C library for loading and wrapping LV2 plugin UIs"
  homepage "https://drobilla.net/software/suil/"
  url "https://download.drobilla.net/suil-0.8.2.tar.bz2"
  sha256 "787608c1e5b1f5051137dbf77c671266088583515af152b77b45e9c3a36f6ae8"

  bottle do
    sha256 "3852905def7079132a6c9ff4f5de8a8ad6eec2708a20e987a92044acb7753364" => :el_capitan
    sha256 "0752b6071b7b0aa47605097a07c3b372f3790816f639791318ddeaf366086e46" => :yosemite
    sha256 "cdf01f1c90d9e540e5f798691554a5ecca4765895db1f3fc4877db3301d72e7d" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "lv2"
  depends_on "gtk+" => :recommended
  depends_on "qt" => :optional
  depends_on "qt5" => :optional
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
