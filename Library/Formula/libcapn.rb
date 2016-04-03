class Libcapn < Formula
  desc "C library to send push notifications to Apple devices"
  homepage "http://libcapn.org/"
  head "https://github.com/adobkin/libcapn.git"

  stable do
    url "https://github.com/adobkin/libcapn/archive/1.1.0.tar.gz"
    sha256 "fbe93f8fad4247b898d518ea0f38484eb062cd830a41bb26a6ac4b95cbf076e4"

    resource "jansson" do
      url "https://github.com/akheron/jansson/archive/v2.5.tar.gz"
      sha256 "f328f25fc74a14b6a636245ad28d4cd3affd792f7ffaab4c021a99b3694e4287"
    end
  end

  bottle do
    cellar :any
    sha256 "228057a01ee8f67b8cb4122798d12e19b596c7cb1c5c7bc216ade96a0a632ef4" => :el_capitan
    sha256 "35071a03d946979792e7ac7792e2bf6e94073c242ccf58066fefd0d49c7d72d4" => :yosemite
    sha256 "70d7e47ff2ad168c6f26e61d86805b4e0d1c37015c1e3528d589195a66e9d185" => :mavericks
  end

  devel do
    url "https://github.com/adobkin/libcapn/archive/2.0.0-beta.tar.gz"
    sha256 "551dccfa66b616a390e3c9fc8ac35869a076c979246728e9343f9eeb50d66551"
    version "2.0.0-beta"

    resource "jansson" do
      url "https://github.com/akheron/jansson.git", :revision => "e44b2231b50aea5de78b7ea2debec0d5327cd711"
    end
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    if build.stable?
      (buildpath/"jansson").install resource("jansson")
    elsif build.devel?
      (buildpath/"src/third_party/jansson").install resource("jansson")
    end
    cmake_args = std_cmake_args
    cmake_args << "-DOPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}"
    system "cmake", ".", *cmake_args
    system "make", "install"
    example = if build.stable?
      "docs/send_push.c"
    elsif build.head? || build.devel?
      "examples/send_push_message.c"
    end
    (doc/"examples").install example
  end

  test do
    spec = Tab.for_name("libcapn").source["spec"]
    example = if spec == "stable"
      "send_push.c"
    elsif spec == "head" || spec == "devel"
      "send_push_message.c"
    end
    cp "#{doc}/examples/#{example}", testpath
    flags = [
      "-I#{Formula["openssl"].opt_prefix}/include",
      "-I#{include}/capn",
      "-L#{lib}/capn",
      "-lcapn",
      ENV.cflags.to_s.split,
    ].flatten
    system ENV.cc, "-o", "example", example, *flags
    if spec == "stable"
      assert_match /unable to use specified SSL certificate \(12\)/, shell_output("./example", 1)
    elsif spec == "head" || spec == "devel"
      assert_match /unable to use specified PKCS12 file \(errno: 9012\)/, shell_output("./example", 255)
    end
  end
end
