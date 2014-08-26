require "formula"

class Mesos < Formula
  homepage "http://mesos.apache.org"
  url "http://mirror.cogentco.com/pub/apache/mesos/0.19.1/mesos-0.19.1.tar.gz"
  sha1 "3f219313324f86e11df25688ccb86c2814ab29c5"

  bottle do
    sha1 "2758230a98122a25764c7fc4358f45b16c013464" => :mavericks
    sha1 "96d0ab4739014e7c51796209a5ce911142f9ac9e" => :mountain_lion
  end

  depends_on :java => "1.7"
  depends_on :macos => :mountain_lion

  depends_on "maven" => :build

  def install
    system "./configure", "--disable-debug",
                           "--disable-dependency-tracking",
                           "--disable-silent-rules",
                           "--prefix=#{prefix}"

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
