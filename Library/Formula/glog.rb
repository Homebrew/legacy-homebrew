require "formula"

class Glog < Formula
  homepage "https://code.google.com/p/google-glog/"
  url "https://google-glog.googlecode.com/files/glog-0.3.3.tar.gz"
  sha1 "ed40c26ecffc5ad47c618684415799ebaaa30d65"

  # Vendor an older version of gflags as the new version makes compile = nope.
  resource "gflags" do
    url "https://gflags.googlecode.com/files/gflags-2.0.tar.gz"
    sha1 "dfb0add1b59433308749875ac42796c41e824908"
  end

  if MacOS.version >= :mavericks
    # Since 0.3.4 has not yet been released, manually apply
    # r134 that refactors the way headers are included.
    patch do
      url "https://gist.githubusercontent.com/danslo/7128754/raw/9b19991da4753f5efb87ae9a6939e6c3e9bc1fdf/glog_logging_r134.diff"
      sha1 "a4a1a3d1467115f927935c441715b0f8c362abba"
    end

    # Don't use tr1 prefix when we're using libc++:
    # https://code.google.com/p/google-glog/issues/detail?id=121 (patch mirrored on gist.github.com)
    patch do
      url "https://gist.githubusercontent.com/noahm/7364571/raw/436283200fe5a3ac5d00d769bb2203260bebfcf9/libc%2B%2B.diff"
      sha1 "14fe8c422a92ebd6908861ee22cfe1a689191c18"
    end
  end

  def install
    resource("gflags").stage do
      system "./configure", "--disable-dependency-tracking", "--prefix=#{libexec}/gflags"
      system "make", "install"
    end

    # Find our sandboxed gflags.
    ENV.append_to_cflags "-I#{libexec}/gflags/include"
    ENV.append "LDFLAGS", "-L#{libexec}/gflags/lib"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "#{libexec}/gflags/lib/libgflags.2.dylib (compatibility version 4.0.0, current version 4.0.0)",
    shell_output("otool -L #{lib}/libglog.0.dylib | grep libgflags").strip
  end
end
