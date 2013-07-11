require 'formula'

class Igloo < Formula
  homepage 'http://igloo-testing.org'
  url 'https://github.com/joakimkarlsson/igloo/archive/igloo.1.0.0.tar.gz'
  sha1 'f6b538862e4b83e1a389b27fd79f1b89ff1f3c76'
  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    include.install "igloo"
    bin.install "bin/igloo-tests" => "igloo-tests"
  end

  test do
    system "igloo-tests"
  end
end
