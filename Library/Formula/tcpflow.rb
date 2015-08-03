class Tcpflow < Formula
  desc "TCP flow recorder"
  homepage "https://github.com/simsong/tcpflow"
  url "http://digitalcorpora.org/downloads/tcpflow/tcpflow-1.4.4.tar.gz"
  sha256 "b6f5605e7e3f71d004736f4ded9e2a4f5c2233d3423019f3dc0af56037ed544c"

  head do
    url "https://github.com/simsong/tcpflow.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "boost" => :build
  depends_on "sqlite" if MacOS.version < :lion
  depends_on "openssl"

  stable do
    # Upstream fix for 10.6; can be removed in next release
    patch do
      url "https://github.com/simsong/tcpflow/commit/1cd5a9168c2ebf72c1fadcd64634398bd8470bce.diff"
      sha256 "6c3aae2f3a140847a9333c5f4d1e94bddb60e79b7c7ee2d13a2cc116fd9620c3"
    end
  end

  def install
    system "bash", "./bootstrap.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
