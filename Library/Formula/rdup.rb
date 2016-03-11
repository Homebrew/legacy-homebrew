class Rdup < Formula
  desc "Utility to create a file list suitable for making backups"
  homepage "https://github.com/miekg/rdup"
  url "https://github.com/miekg/rdup/archive/1.1.15.tar.gz"
  sha256 "787b8c37e88be810a710210a9d9f6966b544b1389a738aadba3903c71e0c29cb"
  head "https://github.com/miekg/rdup.git"

  bottle do
    cellar :any
    sha256 "c9afd06e3d3cfb9628c9618723d1913916f2563d2b18159cffe2b2586ce0c508" => :el_capitan
    sha256 "0b83116666ac22439d46a6d92f6d75eb3dd7f231021dbc441c2388b4bd076e00" => :yosemite
    sha256 "ddfd0b0a7116c618739caffb054a0b149e17c7bf517c512ccb1543c3e7784275" => :mavericks
  end

  option "with-test", "Verify the build with `make check`"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "nettle"
  depends_on "pcre"
  depends_on "glib"
  depends_on "libarchive"
  depends_on "mcrypt"

  if build.with? "test"
    depends_on "deja-gnu" => :build
    depends_on "gnu-sed" => :build
    depends_on "coreutils" => :build
    depends_on "gnu-tar" => :build
  end

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}"
    system "make"

    if build.with? "test"
      saved_path = ENV["PATH"]
      ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin"
      ENV.prepend_path "PATH", Formula["coreutils"].opt_libexec/"gnubin"
      ENV.prepend_path "PATH", Formula["gnu-tar"].opt_libexec/"gnubin"
      system "make", "check"
      ENV["PATH"] = saved_path
    end

    system "make", "install"
  end

  test do
    # tell rdup to archive itself, then let rdup-tr make a tar archive of it,
    # and test with tar and grep whether the resulting tar archive actually
    # contains rdup
    system "#{bin}/rdup /dev/null #{bin}/rdup | #{bin}/rdup-tr -O tar | tar tvf - | grep #{bin}/rdup"
  end
end
