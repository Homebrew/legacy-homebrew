class Icecast < Formula
  desc "Streaming MP3 audio server"
  homepage "http://www.icecast.org/"
  url "http://downloads.xiph.org/releases/icecast/icecast-2.4.2.tar.gz"
  sha256 "aa1ae2fa364454ccec61a9247949d19959cb0ce1b044a79151bf8657fd673f4f"

  bottle do
    sha256 "67df949d0febfeb38c0336609d41db59b3cc5e6be4e031689eab4acfcd5e9c9d" => :yosemite
    sha256 "531becfe2f4227b94aac8bf14fa4b231f7ff90b106ee4edde6d8dc20d556e6dd" => :mavericks
    sha256 "fa2b6d0fb4721902671979b55bee219cf27a4e01e20fa855c73094d03890c423" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libogg" => :optional
  depends_on "theora" => :optional
  depends_on "speex"  => :optional
  depends_on "openssl"
  depends_on "libvorbis"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    (prefix+"var/log/icecast").mkpath
    touch prefix+"var/log/icecast/error.log"
  end
end
