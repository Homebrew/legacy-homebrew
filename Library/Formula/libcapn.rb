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
    sha256 "09cbbfc8fb5037b3ec0c5ef70e79dbbf47370fb382284857ea333c3459179f9f" => :yosemite
    sha256 "1113b788db1d53843e20693d668f5847957c04c83eefb14da41bf57778e61f48" => :mavericks
    sha256 "eb99972edf809a3d2ea12c56bd7461574f4a108565e9ad75e1341cbf846f2b80" => :mountain_lion
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
