require 'formula'

class Unixodbc < Formula
  homepage 'http://www.unixodbc.org/'
  url 'http://www.unixodbc.org/unixODBC-2.3.2.tar.gz'
  sha1 'f84520fd58143625b614fde551435178a558ee2e'

  conflicts_with 'virtuoso', :because => 'Both install `isql` binaries.'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-gui=no"
    system "make install"
  end
end
