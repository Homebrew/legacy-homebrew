class Mtools < Formula
  desc "Tools for manipulating MSDOS files"
  homepage "https://www.gnu.org/software/mtools/"
  url "http://ftpmirror.gnu.org/mtools/mtools-4.0.17.tar.gz"
  mirror "https://ftp.gnu.org/gnu/mtools/mtools-4.0.17.tar.gz"
  sha256 "8fff9d6a09c700ee0a65b45f2436b96acb32e3c551acb3ff04275d51534cf7da"

  bottle do
    cellar :any
    sha256 "cac73cd7c693d22fc8472259f58d85c99f790950d3a7b30643af4541441d60e4" => :yosemite
    sha256 "e3d237ea8239d815b8bd2ad5b3e0e0904e06b606d13d5c1f1a9c99ed4c2764d7" => :mavericks
    sha256 "559d465879ac7d26d84522e4315447695354d9be98a5930cb05b27a8ecf9555a" => :mountain_lion
  end

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
