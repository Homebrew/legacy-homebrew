class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "http://www.sysdig.org/"
  url "https://github.com/draios/sysdig/archive/0.1.101.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/s/sysdig/sysdig_0.1.101.orig.tar.gz"
  sha256 "6995e39be565514901b5cb587689ee2efbf8359293e4e597362382cccf0e9db6"

  bottle do
    sha256 "42cf03077f83db8d0171ec9139a2d87f28bbe76f4311db8518d87e153d857192" => :yosemite
    sha256 "cbe221595e2e49772a669abaebc8da1ba1d91dab561ad4515318d3a17e7461f4" => :mavericks
    sha256 "9e7f40f91e50bdc256835a5f5b15e8469f09477fc3164d4bad385614a65b3f10" => :mountain_lion
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
