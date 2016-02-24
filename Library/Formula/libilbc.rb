class Libilbc < Formula
  desc "Packaged version of iLBC codec from the WebRTC project"
  homepage "https://github.com/TimothyGu/libilbc"
  url "https://github.com/TimothyGu/libilbc/releases/download/v2.0.2/libilbc-2.0.2.tar.gz"
  sha256 "84d5c99087a35bda3463bcb993245b4f8c28c04fe037215a5ec56570f68ce519"

  bottle do
    cellar :any
    sha256 "fff34390e949e037bb4b16937b62ab4993f55d2fb805656116ceab6a7c9b6e83" => :el_capitan
    sha256 "7f16b3e0f254f35be8b6275339dc813a6443f65d1c27e1748e08835a49733f6f" => :yosemite
    sha256 "7aa8495e4050ea38152ec218452d6fac97387ad385a6d63806238e838664471b" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <ilbc.h>
      #include <stdio.h>

      int main() {
        char version[255];

        WebRtcIlbcfix_version(version);
        printf("%s", version);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lilbc", "-o", "test"
    system "./test"
  end
end
