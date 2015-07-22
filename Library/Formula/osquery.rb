class Osquery < Formula
  desc "SQL powered operating system instrumentation and analytics"
  homepage "https://osquery.io"
  # pull from git tag to get submodules
  url "https://github.com/facebook/osquery.git",
      :tag => "1.5.0",
      :revision => "ca09fdb9f80ed632b98a2a9c41a521309e14b611"
  revision 1

  bottle do
    sha256 "2056d44c6b15b9e38619b457974d8b83f041701934743ddfeac19cacb5ffeb21" => :yosemite
  end

  # osquery only support OS X Yosemite and above. Do not remove this.
  depends_on :macos => :yosemite

  depends_on "cmake" => :build
  depends_on "boost" => :build
  depends_on "doxygen" => :build
  depends_on "rocksdb" => :build
  depends_on "thrift" => :build
  depends_on "yara" => :build
  depends_on "openssl"
  depends_on "gflags"

  resource "markupsafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.7.3.tar.gz"
    sha256 "2e24ac5d004db5714976a04ac0e80c6df6e47e98c354cb2c0d82f8879d4f8fdb"
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
    require "open3"
    Open3.popen3("#{bin}/osqueryi") do |stdin, stdout, _|
      stdin.write(".mode line\nSELECT count(version) as lines FROM osquery_info;")
      stdin.close
      assert_equal "lines = 1\n", stdout.read
    end
  end
end
