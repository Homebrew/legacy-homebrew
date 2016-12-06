require 'formula'

class Nanomsg < Formula
  homepage 'http://nanomsg.org'
  url 'http://download.nanomsg.org/nanomsg-0.1-alpha.tar.gz'
  sha1 '6b2d9bd60bfcf9377befa006608598716e1c1fe9'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
  end
end
