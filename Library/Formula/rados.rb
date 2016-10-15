class Rados < Formula
  desc "RADOS is a library for connecting and utilizing Ceph"
  homepage "http://ceph.com/"
  head "https://github.com/ceph/ceph.git"

  depends_on "libtool" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "snappy"
  depends_on "cryptopp"
  depends_on "boost"
  depends_on "leveldb"
  depends_on "python"

  def install
    system "./autogen.sh"

    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    system "./configure", "--without-fuse",
                          "--without-tcmalloc",
                          "--without-libaio",
                          "--without-libxfs",
                          "--with-rados",
                          "--without-rbd",
                          "--without-cephfs",
                          "--without-radosgw",
                          "--without-selinux",
                          "--without-radosstriper",
                          "--without-mon",
                          "--without-mds",
                          "--without-debug",
                          "--without-libatomic-ops",
                          "--disable-client",
                          "--disable-server",
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
    system "#{bin}/rados"
  end
end
