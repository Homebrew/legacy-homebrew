class Libnfs < Formula
  desc "C client library for NFS"
  homepage "https://github.com/sahlberg/libnfs"
  url "https://github.com/sahlberg/libnfs/archive/libnfs-1.9.7.tar.gz"
  sha256 "7c2e088f5fd85b791ab644a5221b717894208bc5fb8b8a5a49633802ecaa0990"

  bottle do
    cellar :any
    sha256 "5e5b0bef16c703596a928b0ff474264745f2b33a86041af948a2736f41713a5e" => :yosemite
    sha256 "7e89a3a33331387578ae4ef53037960c689e19c2f4a788f7763841d3036e8e0d" => :mavericks
  end

  depends_on "libtool" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <nfsc/libnfs.h>

      int main(void)
      {
        int result = 1;
        struct nfs_context *nfs = NULL;
        nfs = nfs_init_context();

        if (nfs != NULL) {
            result = 0;
            nfs_destroy_context(nfs);
        }

        return result;
      }
    EOS
    system ENV.cc, "test.c", "-lnfs", "-o", "test"
    system "./test"
  end
end
