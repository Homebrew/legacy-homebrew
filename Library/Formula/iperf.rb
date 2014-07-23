require 'formula'

class Iperf < Formula
  homepage 'http://iperf.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/iperf/iperf-2.0.5.tar.gz'
  sha1 '7302792dcb1bd7aeba032fef6d3dcc310e4d113f'

  bottle do
    cellar :any
    sha1 "ce3cc45d64a0be38f489d96bb9c816e8ef1ded77" => :mavericks
    sha1 "831b48b0a1eb3822323e637bfb29df1da31df7ff" => :mountain_lion
    sha1 "a11c989cfaaa79438ca6c77ec9d038a139562692" => :lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
