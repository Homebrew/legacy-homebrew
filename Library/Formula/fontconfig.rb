require 'formula'

class Fontconfig < Formula
  homepage 'http://fontconfig.org/'
  url 'http://fontconfig.org/release/fontconfig-2.11.1.tar.bz2'
  sha1 '08565feea5a4e6375f9d8a7435dac04e52620ff2'

  bottle do
    sha1 "c576b65e8c2f50459e4f82797977ee3951b58ab1" => :mavericks
    sha1 "ab5545151307fc9ec617a9b291f16f5b83ef5895" => :mountain_lion
    sha1 "37170b464e3ef08a56662c2b2a6311ee1bd3602e" => :lion
  end

  keg_only :provided_pre_mountain_lion

  option :universal

  depends_on :freetype
  depends_on 'pkg-config' => :build

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-add-fonts=/System/Library/Fonts,/Library/Fonts,~/Library/Fonts",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}"
    system "make", "install", "RUN_FC_CACHE_TEST=false"
  end

  def post_install
    system "#{bin}/fc-cache", "-frv"
  end
end
