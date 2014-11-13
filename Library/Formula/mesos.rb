require "formula"

class Mesos < Formula
  homepage "http://mesos.apache.org"
  url "http://mirror.cogentco.com/pub/apache/mesos/0.20.1/mesos-0.20.1.tar.gz"
  sha1 "8028366a2538551daaf290f7c62c4c8bfb415f61"

  bottle do
    revision 1
    sha1 "8fe843863e10aa82cc14e4f7c9989e1296bf8e5b" => :mavericks
    sha1 "410c88697079563e148b42d4f36ee3687e563b1d" => :mountain_lion
  end

  depends_on :java => "1.7"
  depends_on :macos => :mountain_lion
  depends_on "maven" => :build
  # Use our Zookeeper for Yosemite and not the one shipped with Mesos
  # Remove with next release.
  # See https://github.com/Homebrew/homebrew/issues/32965
  depends_on "zookeeper" if MacOS.version == :yosemite


  def install
    args = ["--prefix=#{prefix}",
            "--disable-debug",
            "--disable-dependency-tracking",
            "--disable-silent-rules"
           ]

    args << "--with-zookeeper=#{Formula["zookeeper"].opt_prefix}" if MacOS.version == :yosemite

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
    Timeout::timeout(15) do
      system "#{bin}/mesos", "execute",
                             "--master=127.0.0.1:5050",
                             "--name=execute-touch",
                             "--command=touch\s#{testpath}/executed"
    end
    Process.kill("TERM", master)
    Process.kill("TERM", slave)
    system "[ -e #{testpath}/executed ]"
  end
end
