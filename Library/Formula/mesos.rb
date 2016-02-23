class Mesos < Formula
  desc "Apache cluster manager"
  homepage "https://mesos.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=mesos/0.27.1/mesos-0.27.1.tar.gz"
  mirror "https://archive.apache.org/dist/mesos/0.27.1/mesos-0.27.1.tar.gz"
  sha256 "889ecf6c1eb2e41fe06561e2534404e5a597273519c1d0e9c23381c8f7c1f190"

  bottle do
    sha256 "b79ec00ee495423091cb62c144d7f0afecc96cbcf750757c6431ef87c075c495" => :el_capitan
    sha256 "b8d50cd3bfbe9ce509afc75f694104efda1c494f0627735cf50ef3bfe38f5170" => :yosemite
    sha256 "0c3908c9c474796da6aa4d186ae720d7ae6088d1319a8954aff92efef1328dcb" => :mavericks
  end

  depends_on :java => "1.7+"
  depends_on :macos => :mountain_lion
  depends_on :apr => :build
  depends_on "maven" => :build
  depends_on "subversion"

  resource "boto" do
    url "https://pypi.python.org/packages/source/b/boto/boto-2.36.0.tar.gz"
    sha256 "8033c6f7a7252976df0137b62536cfe38f1dbd1ef443a7a6d8bc06c063bc36bd"
  end

  resource "protobuf" do
    url "https://pypi.python.org/packages/source/p/protobuf/protobuf-2.6.1.tar.gz"
    sha256 "8faca1fb462ee1be58d00f5efb4ca4f64bde92187fe61fde32615bbee7b3e745"
  end

  # build dependencies for protobuf
  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.4.0.tar.gz"
    sha256 "439df33ce47ef1478a4f4765f3390eab0ed3ec4ae10be32f2930000c8d19f417"
  end

  resource "pytz" do
    url "https://pypi.python.org/packages/source/p/pytz/pytz-2014.10.tar.bz2"
    sha256 "387f968fde793b142865802916561839f5591d8b4b14c941125eb0fca7e4e58d"
  end

  resource "python-gflags" do
    url "https://pypi.python.org/packages/source/p/python-gflags/python-gflags-2.0.tar.gz"
    sha256 "0dff6360423f3ec08cbe3bfaf37b339461a54a21d13be0dd5d9c9999ce531078"
  end

  resource "google-apputils" do
    url "https://pypi.python.org/packages/source/g/google-apputils/google-apputils-0.4.2.tar.gz"
    sha256 "47959d0651c32102c10ad919b8a0ffe0ae85f44b8457ddcf2bdc0358fb03dc29"
  end

  needs :cxx11

  def install
    ENV.java_cache

    boto_path = libexec/"boto/lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", boto_path
    resource("boto").stage do
      system "python", *Language::Python.setup_install_args(libexec/"boto")
    end
    (lib/"python2.7/site-packages").mkpath
    (lib/"python2.7/site-packages/homebrew-mesos-boto.pth").write "#{boto_path}\n"

    # work around distutils abusing CC instead of using CXX
    # https://issues.apache.org/jira/browse/MESOS-799
    # https://github.com/Homebrew/homebrew/pull/37087
    native_patch = <<-EOS.undent
      import os
      os.environ["CC"] = os.environ["CXX"]
      os.environ["LDFLAGS"] = "@LIBS@"
      \\0
    EOS
    inreplace "src/python/native/setup.py.in",
              "import ext_modules",
              native_patch

    # skip build javadoc because Homebrew sandbox ENV.java_cache
    # would trigger maven-javadoc-plugin bug.
    # https://issues.apache.org/jira/browse/MESOS-3482
    maven_javadoc_patch = <<-EOS.undent
      <properties>
        <maven.javadoc.skip>true</maven.javadoc.skip>
      </properties>
      \\0
    EOS
    inreplace "src/java/mesos.pom.in",
              "<url>http://mesos.apache.org</url>",
              maven_javadoc_patch

    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --with-svn=#{Formula["subversion"].opt_prefix}
    ]

    unless MacOS::CLT.installed?
      args << "--with-apr=#{Formula["apr"].opt_prefix}/libexec"
    end

    ENV.cxx11

    system "./configure", "--disable-python", *args
    system "make"
    system "make", "install"

    system "./configure", "--enable-python", *args
    ["native", "interface", "cli", ""].each do |p|
      cd "src/python/#{p}" do
        system "python", *Language::Python.setup_install_args(prefix)
      end
    end

    # stage protobuf build dependencies
    ENV.prepend_create_path "PYTHONPATH", buildpath/"protobuf/lib/python2.7/site-packages"
    %w[six python-dateutil pytz python-gflags google-apputils].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(buildpath/"protobuf")
      end
    end

    protobuf_path = libexec/"protobuf/lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", protobuf_path
    resource("protobuf").stage do
      ln_s buildpath/"protobuf/lib/python2.7/site-packages/google/apputils", "google/apputils"
      system "python", *Language::Python.setup_install_args(libexec/"protobuf")
    end
    pth_contents = "import site; site.addsitedir('#{protobuf_path}')\n"
    (lib/"python2.7/site-packages/homebrew-mesos-protobuf.pth").write pth_contents
  end

  test do
    require "timeout"

    master = fork do
      exec "#{sbin}/mesos-master", "--ip=127.0.0.1",
                                   "--registry=in_memory"
    end
    slave = fork do
      exec "#{sbin}/mesos-slave", "--master=127.0.0.1:5050",
                                  "--work_dir=#{testpath}"
    end
    Timeout.timeout(15) do
      system "#{bin}/mesos", "execute",
                             "--master=127.0.0.1:5050",
                             "--name=execute-touch",
                             "--command=touch\s#{testpath}/executed"
    end
    Process.kill("TERM", master)
    Process.kill("TERM", slave)
    assert File.exist?("#{testpath}/executed")
    system "python", "-c", "import mesos.native"
  end
end
