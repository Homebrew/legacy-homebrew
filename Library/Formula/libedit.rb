require "formula"

class Libedit < Formula
  homepage "http://thrysoee.dk/editline/"
  url "http://thrysoee.dk/editline/libedit-20140620-3.1.tar.gz"
  version "3.1"
  sha1 "9c0fc40ac9336af9af0799bcdfd3537a6ad258ff"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
