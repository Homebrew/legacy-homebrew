require 'formula'

class JsonC < Formula
  homepage 'https://github.com/json-c/json-c/wiki'
  url 'https://github.com/json-c/json-c/archive/json-c-0.11-20130402.tar.gz'
  version '0.11'
  sha1 '1910e10ea57a743ec576688700df4a0cabbe64ba'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    ENV.deparallelize
    system "make install"
  end
end
