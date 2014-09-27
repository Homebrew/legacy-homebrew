require "formula"

class Mesos < Formula
  homepage "http://mesos.apache.org"
  url "http://mirror.cogentco.com/pub/apache/mesos/0.20.1/mesos-0.20.1.tar.gz"
  sha1 "8028366a2538551daaf290f7c62c4c8bfb415f61"

  bottle do
    sha1 "d51f509321860fd7322eae16ca33a76dcf7313f7" => :mavericks
    sha1 "478a96a214091a143c88f9889f212bdacc566912" => :mountain_lion
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
