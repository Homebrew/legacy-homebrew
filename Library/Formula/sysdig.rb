require "formula"

class Sysdig < Formula
  homepage "http://www.sysdig.org/"
  url "https://github.com/draios/sysdig/archive/0.1.95.tar.gz"
  sha1 "0e07da4fa4b9d8917e73591ee8d60f43e9bacef6"

  head "https://github.com/draios/sysdig.git"

  bottle do
    sha1 "20fd60684494c2355a6726185005f1c0ddd2a62e" => :yosemite
    sha1 "5014884980a74ab57b7301e09c8491676ffd4729" => :mavericks
    sha1 "00630d947388152c452d07583d1d50998143128f" => :mountain_lion
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

    assert_equal expected_output, `#{bin}/sysdig -r #{share}/demos/sample.scap -p "%evt.num %evt.type %evt.args" "evt.type=open and evt.arg.name contains /tmp/sysdig/sample.scap"`.strip
    assert_equal 0, $?.exitstatus
  end
end
