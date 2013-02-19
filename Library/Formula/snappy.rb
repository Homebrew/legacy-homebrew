require 'formula'

class Snappy < Formula
  homepage 'http://snappy.googlecode.com'
  url 'http://snappy.googlecode.com/files/snappy-1.1.0.tar.gz'
  sha1 '17cde387e0f19112d647095624e5ed4051b753be'

  option :universal

  depends_on 'pkg-config' => :build

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
