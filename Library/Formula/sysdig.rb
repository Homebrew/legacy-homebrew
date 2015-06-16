class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "http://www.sysdig.org/"
  url "https://github.com/draios/sysdig/archive/0.1.101.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/s/sysdig/sysdig_0.1.101.orig.tar.gz"
  sha256 "6995e39be565514901b5cb587689ee2efbf8359293e4e597362382cccf0e9db6"

  bottle do
    sha256 "469d034cfc2aa2788d3c235f9201b48e9633e3832aca6efdd83c05a29246f164" => :yosemite
    sha256 "1019e1c5a1b4b13085089b61ecb6c61598573b8af88b8b430e81ece527e0e17c" => :mavericks
    sha256 "bb8f97dc545bfa14a331e65222d072af4bbc3213e3da50a822e02770b0850e5c" => :mountain_lion
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
