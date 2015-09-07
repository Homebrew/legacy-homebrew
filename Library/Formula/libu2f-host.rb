class Libu2fHost < Formula
  desc "Host-side of the Universal 2nd Factor (U2F) protocol"
  homepage "https://developers.yubico.com/libu2f-host/"
  url "https://developers.yubico.com/libu2f-host/Releases/libu2f-host-1.0.0.tar.xz"
  sha256 "18c56b9b5cfea2566925bba45b25a4e20b3ef8696905d8f2a06116316e164374"

  depends_on "pkg-config" => :build
  depends_on "hidapi"
  depends_on "json-c"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <u2f-host.h>
      int main()
      {
        u2fh_devs *devs;
        u2fh_global_init (0);
        u2fh_devs_init (&devs);
        u2fh_devs_discover (devs, NULL);
        u2fh_devs_done (devs);
        u2fh_global_done ();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-I#{include}/u2f-host", "-L#{lib}", "-lu2f-host"
    system "./test"
  end
end
