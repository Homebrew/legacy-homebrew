require "formula"

class NanopbGenerator < Formula
  homepage "http://koti.kapsi.fi/jpa/nanopb/docs/index.html"
  url "http://koti.kapsi.fi/~jpa/nanopb/download/nanopb-0.2.7.tar.gz"
  sha1 "7dce0b9e1f9e5d0614697a8ea1678cee76f14858"

  depends_on :python
  depends_on "protobuf" => [:python, "google.protobuf"]
  depends_on "protobuf"

  def install
    Dir.chdir 'generator'

    Dir.chdir 'proto' do
      system 'make'
    end

    libexec.install Dir['*']
    bin.write_exec_script libexec/'protoc-gen-nanopb', libexec/'nanopb_generator.py'
  end

  test do
    system "nanopb_generator.py", "--help"
  end
end
