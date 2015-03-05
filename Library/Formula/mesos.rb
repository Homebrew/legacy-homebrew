class Mesos < Formula
  homepage "http://mesos.apache.org"
  url "http://mirror.cogentco.com/pub/apache/mesos/0.21.1/mesos-0.21.1.tar.gz"
  sha1 "275d211364699f2861c108fa80764785178f3eeb"

  bottle do
    revision 1
    sha1 "8fe843863e10aa82cc14e4f7c9989e1296bf8e5b" => :mavericks
    sha1 "410c88697079563e148b42d4f36ee3687e563b1d" => :mountain_lion
  end

  depends_on :java => "1.7+"
  depends_on :macos => :mountain_lion
  depends_on "maven" => :build
  depends_on :apr => :build
  depends_on "subversion"


  needs :cxx11

  def install
    # work around distutils abusing CC instead of using CXX
    # https://issues.apache.org/jira/browse/MESOS-799
    # https://github.com/Homebrew/homebrew/pull/37087
    inreplace "src/python/native/setup.py.in",
              "import ext_modules",
              "import os; os.environ['CC'] = '#{ENV.cxx}'\n\\0"

    args = ["--prefix=#{prefix}",
            "--disable-debug",
            "--disable-dependency-tracking",
            "--disable-silent-rules",
            "--without-python",
            "--with-svn=#{Formula["subversion"].opt_prefix}"
           ]

    unless MacOS::CLT.installed?
      args << "--with-apr=#{Formula["apr"].opt_prefix}/libexec"
    end

    ENV.cxx11

    system "./configure", *args
    system "make"
    system "make", "install"
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
  end
end
