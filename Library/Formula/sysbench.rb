class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://launchpad.net/sysbench"
  url "http://ftp.de.debian.org/debian/pool/main/s/sysbench/sysbench_0.4.12.orig.tar.gz"
  sha256 "83fa7464193e012c91254e595a89894d8e35b4a38324b52a5974777e3823ea9e"
  revision 1

  bottle do
    cellar :any
    sha1 "de4a0e7d639cb56d767a937268ddd02f90737504" => :yosemite
    sha1 "5b14feb02648fa246ff2b3117bda9aa7700737fe" => :mavericks
    sha1 "1b5819b0214bd5fdebe25171fe6840362593e08e" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openssl"
  depends_on :mysql => :recommended
  depends_on :postgresql => :optional

  def install
    inreplace "configure.ac", "AC_PROG_LIBTOOL", "AC_PROG_RANLIB"
    system "./autogen.sh"

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
