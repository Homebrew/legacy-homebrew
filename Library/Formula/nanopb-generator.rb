class NanopbGenerator < Formula
  desc "ANSI C library for encoding and decoding Protocol Buffer messages"
  homepage "http://koti.kapsi.fi/jpa/nanopb/docs/index.html"
  url "http://koti.kapsi.fi/~jpa/nanopb/download/nanopb-0.2.7.tar.gz"
  sha256 "acaac15e0a623451b6db0e8c72233bd765b190e7449c1e0ddd9165d3ef41c223"
  revision 1

  bottle do
    cellar :any
    sha1 "2552d564120cc40eec05204779c4e2725fa0bacd" => :mavericks
    sha1 "f40866f5be494fcd0ecbacc1eccabedfea449084" => :mountain_lion
    sha1 "697c2bcc74f4eb368cdbeb2c512a1555ea0ed14f" => :lion
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
