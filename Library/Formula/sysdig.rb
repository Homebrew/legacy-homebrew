require "formula"

class Sysdig < Formula
  homepage "http://www.sysdig.org/"
  url "https://github.com/draios/sysdig/archive/0.1.89.tar.gz"
  sha1 "a7c97901313cbb81b3bb9ac85d48df568be2ceca"

  head "https://github.com/draios/sysdig.git", :branch => "master"

  bottle do
    revision 1
    sha1 "28d9c5c57ebbf82be59651c617ecfe0091b3c933" => :mavericks
    sha1 "bc257cd2531ac744eab32ca2a87609fd9c076237" => :mountain_lion
    sha1 "3d049582474015808532e6a77329dffed8885341" => :lion
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
