require 'formula'

class Libiodbc < Formula
  homepage 'http://www.iodbc.org/dataspace/iodbc/wiki/iODBC/'
  url 'http://sourceforge.net/projects/iodbc/files/iodbc/3.52.10/libiodbc-3.52.10.tar.gz/download'
  sha1 '2a8328cea84a3ddb78b10a009652cdd3f1d39fb9'

  depends_on 'automake' => :build
  depends_on 'autoconf' => :build
  depends_on 'libtool' => :build

  def install
    # run bootstrap.sh
    system "sh",  "./bootstrap.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/iodbc-config", "--version"
  end
end
