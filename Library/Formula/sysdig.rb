require "formula"

class Sysdig < Formula
  homepage "http://www.sysdig.org/"
  url "https://github.com/draios/sysdig/archive/0.1.92.tar.gz"
  sha1 "77c43f76b1dc987c2d1f5929bf669e9f11b22aaa"

  head "https://github.com/draios/sysdig.git"

  bottle do
    sha1 "a02f92e350fe20bbdd0e3024280cec76978d46b4" => :yosemite
    sha1 "d4649ecb49a3444841be9d37a27e4b11733f0fac" => :mavericks
    sha1 "4849853bc4fdb28f44af8f78f332e82fe9175cce" => :mountain_lion
  end

  depends_on "cmake" => :build

  # More info on https://gist.github.com/juniorz/9986999
  resource "sample_file" do
    url "https://gist.githubusercontent.com/juniorz/9986999/raw/a3556d7e93fa890a157a33f4233efaf8f5e01a6f/sample.scap"
    sha1 "0aa3c30b954f9fb0d7320d900d3a103ade6b1cec"
  end

  def install
    ENV.libcxx if MacOS.version < :mavericks

    mkdir "build" do
      system "cmake", "..", "-DSYSDIG_VERSION=#{version}", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (share/"demos").install resource("sample_file").files("sample.scap")

    # tests if it can load chisels
    `#{bin}/sysdig -cl`
    assert_equal 0, $?.exitstatus

    # tests if it can read a sample capture file
    # uses a custom output format because evt.time (in default format) is not UTC
    expected_output = "1 open fd=5(<f>/tmp/sysdig/sample.scap) name=sample.scap(/tmp/sysdig/sample.scap) flags=262(O_TRUNC|O_CREAT|O_WRONLY) mode=0"

    assert_equal expected_output, `#{bin}/sysdig -r #{share}/demos/sample.scap -p "%evt.num %evt.type %evt.args" evt.type=open fd.name contains /tmp/sysdig/sample.scap`.strip
    assert_equal 0, $?.exitstatus
  end
end
