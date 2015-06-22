class Libprotoident < Formula
  desc "Libprotoident performs application layer protocol identification"
  homepage "http://research.wand.net.nz/software/libprotoident.php"
  url "http://research.wand.net.nz/software/libprotoident/libprotoident-2.0.7.tar.gz"
  sha256 "5063497274e546b01b0606c8906a292cbe1e2ba8d6f3b6cd25de16a91fef635e"

  bottle do
    cellar :any
    sha256 "6e855130c99dffc512308b78811954b6b233bd5bbbb79a0f532cb302dcb346e1" => :yosemite
    sha256 "3c488040b17583688eb485b54f2e08a596d06921c18be68c9d7cb9241037eca7" => :mavericks
    sha256 "f343ff0a3df33dfaf670073a18ad3cf46368cf51b3a1b1c7ec935000f419b99e" => :mountain_lion
  end

  depends_on "libflowmanager"
  depends_on "libwandevent"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <libprotoident.h>

      int main() {
        lpi_init_library();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lprotoident", "-o", "test"
    system "./test"
  end
end
