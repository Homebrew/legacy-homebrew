require 'formula'

class Ctail < Formula
  desc "Tool for operating tail across large clusters of machines"
  homepage 'https://github.com/pquerna/ctail'
  url 'https://github.com/pquerna/ctail/archive/ctail-0.1.0.tar.gz'
  sha1 'be669c11118c29aac4b76540dfcdf245d29a4a92'

  bottle do
    cellar :any
    sha1 "bab0a267f8cf937a80d7d13582d298ecca925e53" => :yosemite
    sha1 "ed024b77815bf8676f3d0842541b077a9950b79a" => :mavericks
    sha1 "58dbf4d30c8fb951a6c86c892098082627b9e3ee" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug"
    system 'make', 'LIBTOOL=glibtool --tag=CC'
    system 'make install'
  end
end
