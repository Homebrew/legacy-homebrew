class Sysdig < Formula
  homepage "http://www.sysdig.org/"
  url "https://github.com/draios/sysdig/archive/0.1.99.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/s/sysdig/sysdig_0.1.99.orig.tar.gz"
  sha256 "e6f00493feaa42f05720c708ab87b7150b465306dae18f9b97f2c40334e2ca09"

  bottle do
    sha1 "a84b9e27e74e38c3f25c1880f0834523c8be1ba8" => :yosemite
    sha1 "ed8ea7f2029d8927abcd0a7a9098acde2aca3c55" => :mavericks
    sha1 "ac90cfe222c6b23182de0a58f73bff178bf0f028" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "luajit"

  # More info on https://gist.github.com/juniorz/9986999
  resource "sample_file" do
    url "https://gist.githubusercontent.com/juniorz/9986999/raw/a3556d7e93fa890a157a33f4233efaf8f5e01a6f/sample.scap"
    sha256 "efe287e651a3deea5e87418d39e0fe1e9dc55c6886af4e952468cd64182ee7ef"
  end

  def install
    ENV.libcxx if MacOS.version < :mavericks

    mkdir "build" do
      args = %W[
        -DSYSDIG_VERSION=#{version}
        -DUSE_BUNDLED_LUAJIT=OFF
        -DUSE_BUNDLED_ZLIB=OFF
      ] + std_cmake_args

      system "cmake", "..", *args
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
