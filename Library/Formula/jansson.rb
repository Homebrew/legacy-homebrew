class Jansson < Formula
  desc "C library for encoding, decoding, and manipulating JSON"
  homepage "http://www.digip.org/jansson/"
  url "http://www.digip.org/jansson/releases/jansson-2.7.tar.gz"
  sha256 "7905e6590fb316c0ff943df3dc6a21cd81a59cff7a6d12514054c359d04d78d7"

  bottle do
    cellar :any
    sha256 "dfcc2f484a285f9a0119e7011702363c5516aaed22a9e4de4d83279e543c98cf" => :el_capitan
    sha1 "7c9087f9ce0f65276339832bbbf7f6f813eed03d" => :yosemite
    sha1 "5c0224602ecb036cdc1e636cff2895094fafac04" => :mavericks
    sha1 "876f6358e0277ddeec6d36c647723452ccf3adfa" => :mountain_lion
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
