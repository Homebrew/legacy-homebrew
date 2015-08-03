class Xdelta < Formula
  desc "Binary diff, differential compression tools"
  homepage "http://xdelta.org"
  url "https://xdelta.googlecode.com/files/xdelta3-3.0.6.tar.gz"
  sha256 "b9a439c27c26e8397dd1b438a2fac710b561e0961fe75682230e6c8f69340da5"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
