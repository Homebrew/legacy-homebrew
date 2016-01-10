class NanopbGenerator < Formula
  desc "ANSI C library for encoding and decoding Protocol Buffer messages"
  homepage "https://koti.kapsi.fi/jpa/nanopb/docs/index.html"
  url "https://koti.kapsi.fi/~jpa/nanopb/download/nanopb-0.3.4.tar.gz"
  sha256 "300e3025ed64cc8e557341c92cd613ef56567f87bb63d75b3718b5899c00f69c"

  bottle do
    cellar :any_skip_relocation
    sha256 "037dba88b75b1e7aee033d7ba2458cbf09894ad8f25b97992b8f7a14acc9a64a" => :el_capitan
    sha256 "312ea6f80babf9d9ee7a06687a97cf40389d718b80a580d07e59d57602a3c66d" => :yosemite
    sha256 "3bb238213b8d28fb4730e0eee3032f0ac25bc8ba16186aa689c28553a90053e5" => :mavericks
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
