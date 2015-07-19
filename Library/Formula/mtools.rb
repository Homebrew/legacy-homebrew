class Mtools < Formula
  desc "Tools for manipulating MSDOS files"
  homepage "https://www.gnu.org/software/mtools/"
  url "http://ftpmirror.gnu.org/mtools/mtools-4.0.17.tar.gz"
  mirror "https://ftp.gnu.org/gnu/mtools/mtools-4.0.17.tar.gz"
  sha256 "8fff9d6a09c700ee0a65b45f2436b96acb32e3c551acb3ff04275d51534cf7da"

  conflicts_with "multimarkdown", :because => "both install `mmd` binaries"

  depends_on :x11 => :optional

  def install
    args = %W[
      LIBS=-liconv
      --disable-debug
      --prefix=#{prefix}
      --sysconfdir=#{etc}
    ]

    if build.with? "x11"
      args << "--with-x"
    else
      args << "--without-x"
    end

    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/mtools --version")
  end
end
