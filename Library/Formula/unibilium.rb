class Unibilium < Formula
  desc "Very basic terminfo library."
  homepage "https://github.com/mauke/unibilium"
  url "https://github.com/mauke/unibilium/archive/v1.2.0.tar.gz"
  sha256 "623af1099515e673abfd3cae5f2fa808a09ca55dda1c65a7b5c9424eb304ead8"

  bottle do
    cellar :any
    sha256 "27f3df4ac52b18aeaae73ce3d84edb2002b3e886b4926be409d09cdbbec233f8" => :yosemite
    sha256 "fafb08a5bf8841d938cfff3aff94ad9ec9c144ec61d495f2eb7e09953715706e" => :mavericks
    sha256 "9cee747128f50066fd632b988065966a7ff1c5ab922e54c16aa05f9d9f50e8be" => :mountain_lion
  end

  depends_on "libtool" => :build

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <unibilium.h>
      #include <stdio.h>

      int main()
      {
        setvbuf(stdout, NULL, _IOLBF, 0);
        unibi_term *ut = unibi_dummy();
        unibi_destroy(ut);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-lunibilium", "-o", "test"
    system "./test"
  end
end
