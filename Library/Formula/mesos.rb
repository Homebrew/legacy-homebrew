class Mesos < Formula
  homepage "https://mesos.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=mesos/0.22.0/mesos-0.22.0.tar.gz"
  mirror "https://archive.apache.org/dist/mesos/0.22.0/mesos-0.22.0.tar.gz"
  sha256 "689f66f63bec043eb1bbf16be1cbe15ea5f359f308f7f5b01dd48075f20e0c7d"

  bottle do
    sha256 "84beeabe62b02983b3f31c65cda9065a44325aecbd717700589e309253c9d64f" => :yosemite
    sha256 "c5e465bf5324dd820173c67cf6764bee66647fdb8aca97c6c17dfadfab1c1ad4" => :mavericks
    sha256 "826b53520eaf9c162904f59bb7fc80a6f5ee0af4c8209d706546de00bcc29c59" => :mountain_lion
  end

  depends_on :java => "1.7+"
  depends_on :macos => :mountain_lion
  depends_on "maven" => :build
  depends_on :apr => :build
  depends_on "subversion"

  resource "boto" do
    url "https://pypi.python.org/packages/source/b/boto/boto-2.36.0.tar.gz"
    sha1 "f230ff9b041d3b43244086e38b7b6029450898be"
  end

  resource "protobuf" do
    url "https://pypi.python.org/packages/source/p/protobuf/protobuf-2.6.1.tar.gz"
    sha1 "3dff24d019729060eff569d7a718bdbb10db13a3"
  end

# build dependencies for protobuf
  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha1 "d168e6d01f0900875c6ecebc97da72d0fda31129"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.4.0.tar.gz"
    sha1 "159081a4c5b3602ab440a7db305f987c00ee8c6d"
  end

  resource "pytz" do
    url "https://pypi.python.org/packages/source/p/pytz/pytz-2014.10.tar.bz2"
    sha1 "74a1869c804dd422afbc49cb92206a0ca1529ddc"
  end

  resource "python-gflags" do
    url "https://pypi.python.org/packages/source/p/python-gflags/python-gflags-2.0.tar.gz"
    sha1 "1529a1102da2fc671f2a9a5e387ebabd1ceacbbf"
  end

  resource "google-apputils" do
    url "https://pypi.python.org/packages/source/g/google-apputils/google-apputils-0.4.2.tar.gz"
    sha1 "6f82069efd1a2cbc168dfb814d077df2fca4cff1"
  end

  needs :cxx11

  def install
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

    args = ["--prefix=#{prefix}",
            "--disable-debug",
            "--disable-dependency-tracking",
            "--disable-silent-rules",
            "--with-svn=#{Formula["subversion"].opt_prefix}"
           ]

    unless MacOS::CLT.installed?
      args << "--with-apr=#{Formula["apr"].opt_prefix}/libexec"
    end

    ENV.cxx11

    system "./configure", "--disable-python", *args
    system "make"
    system "make", "install"

    system "./configure", "--enable-python", *args
    ["native", "interface", ""].each do |p|
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

    (share/"mesos").install "ec2"
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
