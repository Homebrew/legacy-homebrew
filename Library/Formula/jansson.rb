class Jansson < Formula
  desc "C library for encoding, decoding, and manipulating JSON"
  homepage "http://www.digip.org/jansson/"
  url "http://www.digip.org/jansson/releases/jansson-2.7.tar.gz"
  sha256 "7905e6590fb316c0ff943df3dc6a21cd81a59cff7a6d12514054c359d04d78d7"

  bottle do
    cellar :any
    sha256 "dfcc2f484a285f9a0119e7011702363c5516aaed22a9e4de4d83279e543c98cf" => :el_capitan
    sha256 "6b677bb3c1c65b8aae38bec61cdd469c1e3795e89490a3d534ca54034e6fce28" => :yosemite
    sha256 "458c67bd7a25098a2bebd907d8b3271b8044899eaf6ecfc7af55389e23540f91" => :mavericks
    sha256 "b83b62962a3d35669812dc83572860cf783b8eec6974887963a7e0f1c65fb138" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <jansson.h>
      #include <assert.h>

      int main()
      {
        json_t *json;
        json_error_t error;
        json = json_loads("\\"foo\\"", JSON_DECODE_ANY, &error);
        assert(json && json_is_string(json));
        json_decref(json);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-ljansson", "-o", "test"
    system "./test"
  end
end
