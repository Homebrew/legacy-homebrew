require "formula"

class Osquery < Formula
  homepage "http://osquery.io"
  # pull from git tag to get submodules
  url "https://github.com/facebook/osquery.git", :tag => "1.2.2"

  bottle do
    revision 1
    sha1 "a8142c2f22c3547d343a9eb86e3329ed1e4d464c" => :yosemite
    sha1 "a45c7c5b005bb11e8ac414eca0af4dcce77cbe53" => :mavericks
  end

  # Build currently fails on Mountain Lion:
  # https://github.com/facebook/osquery/issues/409
  # Will welcome PRs to fix this!
  depends_on :macos => :mavericks

  depends_on "cmake" => :build

  depends_on "boost"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl"
  depends_on "rocksdb"
  depends_on "thrift"

  resource "markupsafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha1 "cd5c22acf6dd69046d6cb6a3920d84ea66bdf62a"
  end

  resource "jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.7.3.tar.gz"
    sha1 "25ab3881f0c1adfcf79053b58de829c5ae65d3ac"
  end

  def install
    # Apply upstream commit to fix illegal hardware instruction:
    # https://github.com/facebook/osquery/commit/20259a
    # https://github.com/facebook/osquery/issues/563
    # https://github.com/Homebrew/homebrew/issues/35343
    inreplace "CMakeLists.txt", "-Wl,-all_load", "-Wl,-force_load"

    ENV.prepend_create_path "PYTHONPATH", buildpath+"third-party/python/lib/python2.7/site-packages"

    resources.each do |r|
      r.stage { system "python", "setup.py", "install",
                                 "--prefix=#{buildpath}/third-party/python/",
                                 "--single-version-externally-managed",
                                 "--record=installed.txt"}
    end

    system "cmake", ".", *std_cmake_args
    system "make", "install"

    prefix.install "tools/deployment/com.facebook.osqueryd.plist"
  end

  plist_options :startup => true, :manual => "osqueryd"

  test do
    require 'open3'
    Open3.popen3("#{bin}/osqueryi") do |stdin, stdout, _|
      stdin.write(".mode line\nSELECT major FROM osx_version;")
      stdin.close
      assert_equal "major = 10\n", stdout.read
    end
  end
end
