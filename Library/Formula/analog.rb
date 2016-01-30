class Analog < Formula
  desc "Logfile analyzer"
  homepage "https://tracker.debian.org/pkg/analog"
  # The previous long-time homepage and url are stone-cold dead. Using Debian instead.
  # homepage "http://analog.cx"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/a/analog/analog_6.0.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/a/analog/analog_6.0.orig.tar.gz"
  sha256 "31c0e2bedd0968f9d4657db233b20427d8c497be98194daf19d6f859d7f6fcca"
  revision 1

  bottle do
    revision 2
    sha256 "097f11e7f53078e6b248e38fc326cded49b08cdbe75ab61e20ab7b2a6e770256" => :el_capitan
    sha256 "f2f29ea2dcbb9e0576c72f009d8814b0c7f84efd49d6f005085c876c85fd29b9" => :yosemite
    sha256 "c9ca1f30d5b71b7653ecbbdb4ad8d9e81e41b2e33a9dc2c8e0a92af7cd48007d" => :mavericks
  end

  depends_on "gd"
  depends_on "jpeg"
  depends_on "libpng"

  def install
    system "make", "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "DEFS='-DLANGDIR=\"#{pkgshare}/lang/\"' -DHAVE_ZLIB",
                   "LIBS=-lz",
                   "OS=OSX"

    bin.install "analog"
    pkgshare.install "examples", "how-to", "images", "lang"
    pkgshare.install "analog.cfg" => "analog.cfg-dist"
    (pkgshare/"examples").install "logfile.log"
    man1.install "analog.man" => "analog.1"
  end

  test do
    output = pipe_output("#{bin}/analog #{pkgshare}/examples/logfile.log")
    assert_match /(United Kingdom)/, output
  end
end
