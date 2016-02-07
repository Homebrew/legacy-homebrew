class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "http://www.sysdig.org/"
  url "https://github.com/draios/sysdig/archive/0.8.0.tar.gz"
  sha256 "b90dacb27a101526cd21c78a43b336e6752b7cc45f03bb424de0754ed99869a4"

  bottle do
    sha256 "74c39b4da58d955066e2dea2ba8289a8e442eee6e50dffd96301e7ca726ccf0e" => :el_capitan
    sha256 "c4c3de501f493428b1182e8306fe3bd2949fb0ed7cbaf234e22be1885e8d0c53" => :yosemite
    sha256 "cde8850408ad936f0f446a8a7ed0dbe86b8ae99287bbae9c547f60316499c220" => :mavericks
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

    (share/"demos").install resource("sample_file").files("sample.scap")
  end

  test do
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
