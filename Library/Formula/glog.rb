require 'formula'

class Glog < Formula
  homepage 'http://code.google.com/p/google-glog/'
  url 'http://google-glog.googlecode.com/files/glog-0.3.3.tar.gz'
  sha1 'ed40c26ecffc5ad47c618684415799ebaaa30d65'

  depends_on 'gflags'

  def patches
    if MacOS.version >= :mavericks
      {
        # Since 0.3.4 has not yet been released, manually apply
        # r134 that refactors the way headers are included.
        :p1 => "https://gist.github.com/danslo/7128754/raw/9b19991da4753f5efb87ae9a6939e6c3e9bc1fdf/glog_logging_r134.diff",

        # Don't use tr1 prefix when we're using libc++:
        # https://code.google.com/p/google-glog/issues/detail?id=121
        :p0 => "https://google-glog.googlecode.com/issues/attachment?aid=1210003000&name=libc%2B%2B.diff&token=XibcNVdg2suz1w646JbsbHHOkJs%3A1382896876470",
      }
    end
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
