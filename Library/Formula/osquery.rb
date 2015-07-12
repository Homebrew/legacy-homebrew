require "formula"

class Osquery < Formula
  desc "SQL powered operating system instrumentation and analytics"
  homepage "https://osquery.io"
  # pull from git tag to get submodules
  url "https://github.com/facebook/osquery.git", :tag => "1.4.7", :revision => "9d783fee002196c73c4b2622cc7e410d6ce4a4b3"

  bottle do
    sha256 "e6f20336f26db2aaeba7a400f1e2b18e6b385e3b9a17a951b8c5a7c57f815ec1" => :yosemite
  end

  # osquery only support OS X Yosemite and above. Do not remove this.
  depends_on :macos => :yosemite

  depends_on "cmake" => :build
  depends_on "boost" => :build
  depends_on "doxygen" => :build
  depends_on "gflags" => :build
  depends_on "rocksdb" => :build
  depends_on "thrift" => :build
  depends_on "yara" => :build
  depends_on "openssl"

  resource "markupsafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha1 "cd5c22acf6dd69046d6cb6a3920d84ea66bdf62a"
  end

  resource "jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.7.3.tar.gz"
    sha1 "25ab3881f0c1adfcf79053b58de829c5ae65d3ac"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", buildpath+"third-party/python/lib/python2.7/site-packages"

    resources.each do |r|
      r.stage { system "python", "setup.py", "install",
                                 "--prefix=#{buildpath}/third-party/python/",
                                 "--single-version-externally-managed",
                                 "--record=installed.txt"}
    end

    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  plist_options :startup => true, :manual => "osqueryd"

  test do
    require 'open3'
    Open3.popen3("#{bin}/osqueryi") do |stdin, stdout, _|
      stdin.write(".mode line\nSELECT count(version) as lines FROM osquery_info;")
      stdin.close
      assert_equal "lines = 1\n", stdout.read
    end
  end
end
