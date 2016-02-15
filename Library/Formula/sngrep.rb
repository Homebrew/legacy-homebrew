class Sngrep < Formula
  desc "Command-line tool for displaying SIP calls message flows"
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/archive/v1.2.0.tar.gz"
  sha256 "f7f9a05b4be9542ad0651d1deac3bb4cf40c9b1ebc40cfaa922d75a6997f1a7a"

  bottle do
    cellar :any_skip_relocation
    sha256 "13b6e49fd6544efef8d064f1f727b554362460ddf3ddb8f5b09ca3f7dc5e8c46" => :el_capitan
    sha256 "29c33c51721537406e6ba9765f773682c41698c022f2d609bc222630040e4a70" => :yosemite
    sha256 "ced61e1c9760359edf8e63983c68b9513dd68d4aa647559146336dda0dbda1e6" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openssl"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    pipe_output "#{bin}/sngrep -I #{test_fixtures("test.pcap")}", "Q"
  end
end
