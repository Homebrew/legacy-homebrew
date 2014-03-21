require "formula"

class Repmgr < Formula
  homepage "http://www.repmgr.org/"
  url "http://www.repmgr.org/download/repmgr-2.0.tar.gz"
  sha1 "2fa23694b9ee1c9845f026d55995b41c38ab9106"

  depends_on :postgresql

  def install
    system "make", "USE_PGXS=1"
    system "make", "USE_PGXS=1", "install"
  end

  test do
    system "repmgr", "--version"
    system "repmgrd", "--version"
  end
end
