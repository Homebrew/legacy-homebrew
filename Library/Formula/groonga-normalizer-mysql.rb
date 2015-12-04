class GroongaNormalizerMysql < Formula
  desc "MySQL compatible normalizer plugin for Groonga"
  homepage "https://github.com/groonga/groonga-normalizer-mysql"
  url "http://packages.groonga.org/source/groonga-normalizer-mysql/groonga-normalizer-mysql-1.1.0.tar.gz"
  sha256 "525daffdb999b647ce87328ec2e94c004ab59803b00a71ce1afd0b5dfd167116"

  bottle do
    cellar :any
    revision 1
    sha256 "648ffdafe1a451f2e625c5a83221be9e3ce53feb37566e19e39dd73fc9d4b58c" => :el_capitan
    sha256 "849e755495c4594fab0537d9e4c54f4c084a028c727ab4c5f17e5a11a9587cd9" => :yosemite
    sha256 "d8e610269a57e687a258049a62145f4aac617f58dd5ff487cbac07e6b2c37ab2" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "groonga"

  def install
    system "./configure"
    system "make"

    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"
    lib.install Dir["stage/**/lib/*"]
    (share/"doc/groonga-normalizer-mysql").install Dir["stage/**/share/doc/groonga-normalizer-mysql/*"]
  end

  test do
    groonga_bin = Formula["groonga"].opt_bin
    IO.popen("#{groonga_bin}/groonga -n #{testpath}/test.db", "r+") {|io|
      io.puts "register normalizers/mysql"
      sleep 2
      io.close_write
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)
      # expected returned result is like this:
      # [[0,1447502555.38667,0.000824928283691406],true]\n
      assert_match(/[[0,\d+.\d+,\d+.\d+],true]/, io.read)
    }
  end
end
