require "formula"


class Gri < Formula
  homepage "http://gri.sourcegforge.net"
  url "http://downloads.sourceforge.net/project/gri/gri/2.12.23/gri-2.12.23.tar.gz"
  sha1 "75856cc100040da28ba7d667e12301293e7dd5a5"

  depends_on :tex   # Homebrew does not provide a Tex Distribution.
  env :userpaths    # Make sure TeX paths set via /etc/profile (e.g., from MacTeX) are used.

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "gri -v"
  end
end
