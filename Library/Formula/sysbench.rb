class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/s/sysbench/sysbench_0.4.12.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/s/sysbench/sysbench_0.4.12.orig.tar.gz"
  sha256 "83fa7464193e012c91254e595a89894d8e35b4a38324b52a5974777e3823ea9e"
  revision 2

  bottle do
    cellar :any
    sha256 "123270f2b97760e43a575585d1a1b9e815776edaaaa2a33faf419f5d60c18894" => :el_capitan
    sha256 "c55629bcc6aa72d622d7998059136d49993dffd7394467fbf60711252d3f2655" => :yosemite
    sha256 "1128a41e37dc93806e3fe81920cac22c046467e5f2a2d7e4bf2e20c4c8974224" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openssl"
  depends_on :postgresql => :optional
  depends_on :mysql => :recommended

  def install
    inreplace "configure.ac", "AC_PROG_LIBTOOL", "AC_PROG_RANLIB"
    system "./autogen.sh"

    # A horrible horrible backport of fixes in upstream's git for
    # latest mysql detection. Normally would just patch, but we need
    # the autogen above which overwrites a patched configure.
    inreplace "configure" do |s|
      s.gsub! "-lmysqlclient_r", "-lmysqlclient"
      s.gsub! "MYSQL_LIBS=`${mysqlconfig} --libs | sed -e \\",
              "MYSQL_LIBS=`${mysqlconfig} --libs_r`"
      s.gsub! "'s/-lmysqlclient /-lmysqlclient /' -e 's/-lmysqlclient$/-lmysqlclient/'`",
              ""
    end

    args = ["--prefix=#{prefix}"]
    if build.with? "mysql"
      args << "--with-mysql"
    else
      args << "--without-mysql"
    end
    args << "--with-psql" if build.with? "postgresql"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/sysbench", "--test=cpu", "--cpu-max-prime=1", "run"
  end
end
