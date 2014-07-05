require "formula"

class Sysdig < Formula
  homepage "http://www.sysdig.org/"
  url "https://github.com/draios/sysdig/archive/0.1.84.tar.gz"
  sha1 "5eab1585fd59ad7d8cc8ac70a859191c77800c89"

  head "https://github.com/draios/sysdig.git", :branch => "master"

  bottle do
    sha1 "08e75ca529df2e37ea1eac0c911cb78d37c4f802" => :mavericks
    sha1 "aa5dfa1395b859bee3020c2ae86aa5a3a9d68772" => :mountain_lion
    sha1 "8aacd593358a77347da7926d154e0b9a65213d90" => :lion
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
