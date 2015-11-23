class Submarine < Formula
  desc "Search and download subtitles"
  homepage "https://github.com/rastersoft/submarine"
  url "https://github.com/rastersoft/submarine/archive/0.1.4.tar.gz"
  sha256 "c4fbe0786be9aeab95d4df4858f890fae3ca3c06bb28993ae1cd38aa20d1a801"
  head "https://github.com/rastersoft/submarine.git"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "libgee"
  depends_on "libsoup"
  depends_on "libarchive"

  def install
    # Because configure is looking for libgee-0.6 which provided
    # pkg-config viled numbered 1.0.
    #
    # See https://github.com/rastersoft/submarine/pull/1
    inreplace "configure.ac", "gee-1.0", "gee-0.8"
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/submarine", "--help"
  end
end
