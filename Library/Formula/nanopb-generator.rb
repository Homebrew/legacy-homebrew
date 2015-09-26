class NanopbGenerator < Formula
  desc "ANSI C library for encoding and decoding Protocol Buffer messages"
  homepage "http://koti.kapsi.fi/jpa/nanopb/docs/index.html"
  url "http://koti.kapsi.fi/~jpa/nanopb/download/nanopb-0.3.3.tar.gz"
  sha256 "e8288dcef555c7e06e5e9102a523ece35a79c12e73043f4fe34c05ef73cc3bd2"

  bottle do
    cellar :any
    sha256 "e97541bfa7964b7972f029e56f9689b8309cf0c7382b9a365c918b6742000ea8" => :yosemite
    sha256 "bb06e0a18296e67ebc45670971775357d4fe10478bc6e3e9439fb24615caa23c" => :mavericks
    sha256 "5baf3a8d6152b1d878933b2e2199cfbe0873adcc17496f75a99b116e3d8fc6b2" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "protobuf"

  resource "protobuf-python" do
    url "https://pypi.python.org/packages/source/p/protobuf/protobuf-2.6.0.tar.gz"
    sha256 "b1556c5e9cca9069143b41312fd45d0d4785ca0cab682b2624195a6bc4ec296f"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    resource("protobuf-python").stage do
      system "python", "setup.py", "install", "--prefix=#{libexec}"
    end

    Dir.chdir "generator"

    system "make", "-C", "proto"

    libexec.install "nanopb_generator.py", "protoc-gen-nanopb", "proto"

    (bin/"protoc-gen-nanopb").write_env_script libexec/"protoc-gen-nanopb", :PYTHONPATH => ENV["PYTHONPATH"]
    (bin/"nanopb_generator").write_env_script libexec/"nanopb_generator.py", :PYTHONPATH => ENV["PYTHONPATH"]
  end

  test do
    (testpath/"test.proto").write <<-PROTO.undent
      message Test {
        required string test_field = 1;
      }
    PROTO
    system Formula["protobuf"].bin/"protoc",
      "--proto_path=#{testpath}", "--plugin=#{bin}/protoc-gen-nanopb",
      "--nanopb_out=#{testpath}", testpath/"test.proto"
    system "grep", "test_field", testpath/"test.pb.c"
    system "grep", "test_field", testpath/"test.pb.h"
  end
end
