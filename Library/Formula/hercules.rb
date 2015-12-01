class Hercules < Formula
  desc "System/370, ESA/390 and z/Architecture Emulator"
  homepage "http://www.hercules-390.eu/"
  url "http://downloads.hercules-390.eu/hercules-3.12.tar.gz"
  sha256 "aefbe9d2f09372a530c17c177b7d2a0f4bcf8cfd28474672935b067e5f9ee373"

  skip_clean :la

  head do
    url "https://github.com/hercules-390/hyperion.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-optimization=no"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test00.ctl").write <<-EOS.undent
      TEST00 3390 10
      TEST.PDS EMPTY CYL 1 0 5 PO FB 80 6080
    EOS
    system "#{bin}/dasdload", "test00.ctl", "test00.ckd"
  end
end
