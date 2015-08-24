class Unibilium < Formula
  desc "Very basic terminfo library."
  homepage "https://github.com/mauke/unibilium"
  url "https://github.com/mauke/unibilium/archive/v1.2.0.tar.gz"
  sha256 "623af1099515e673abfd3cae5f2fa808a09ca55dda1c65a7b5c9424eb304ead8"

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
