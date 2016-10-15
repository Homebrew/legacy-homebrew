require 'formula'

class Rcssmonitor < Formula
  homepage 'http://sserver.sourceforge.net/'
  url 'https://downloads.sourceforge.net/sserver/rcssmonitor/15.1.0/rcssmonitor-15.1.0.tar.gz'
  sha1 '9a2c1905429882291267b463ec1db858ab0dde90'

  depends_on 'pkg-config' => :build
  depends_on 'qt'
  depends_on 'boost'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rcssmonitor --version | tail -1 | grep 'rcssmonitor Version 15.1.0'"
  end
end
