class Ceph < Formula
  desc "Ceph is a scaleable distributed file system. Client tools/libraries only."
  homepage "http://ceph.com/"
  head "https://github.com/ceph/ceph.git"

  depends_on "libtool" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "snappy"
  depends_on "cryptopp"
  depends_on "boost"
  depends_on "leveldb"

  def install
    # Fixup install location of ceph-detect-init
    inreplace "src/ceph-detect-init/Makefile.am", "python setup.py install $$root $$options", "python setup.py install --prefix #{lib}/python2.7/site-packages --single-version-externally-managed --record=installed.txt"

    system "./autogen.sh"

    ENV.append "CPPFLAGS", "-DGTEST_USE_OWN_TR1_TUPLE=1"
    system "./configure", "--with-rados",
                          "--with-radosstriper",
                          "--enable-client",
                          "--disable-server",
                          "--without-tcmalloc",
                          "--without-fuse",
                          "--without-libaio",
                          "--without-libxfs",
                          "--without-rbd",
                          "--without-cephfs",
                          "--without-radosgw",
                          "--without-selinux",
                          "--without-mon",
                          "--without-mds",
                          "--without-debug",
                          "--without-libatomic-ops",
                          "--disable-coverage",
                          "--disable-pgrefdebugging",
                          "--disable-cephfs-java",
                          "--disable-xio",
                          "--disable-valgrind",
                          "--without-libzfs",
                          "--without-lttng",
                          "--without-babeltrace",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/rados", "--help"
    system "#{bin}/librados-config --version"
  end
end
