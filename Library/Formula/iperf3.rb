require 'formula'

class Iperf3 < Formula
  homepage 'https://code.google.com/p/iperf/'
  url 'http://stats.es.net/software/iperf-3.0.tar.gz'
  sha1 '70df38f93f9c57987e00c7fd11f599944bbcae55'
  head 'https://code.google.com/p/iperf/', :using => :hg

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "clean"      # there are pre-compiled files in the tarball
    system "make", "install"
  end

  test do
    system "#{bin}/iperf3", "--version"
  end
end
