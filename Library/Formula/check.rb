require 'formula'

class Check < Formula
  homepage 'http://check.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/check/check/0.9.12/check-0.9.12.tar.gz'
  sha1 'eaa4c1c3273901b63c7bf054d402b554ad8dd9c9'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
