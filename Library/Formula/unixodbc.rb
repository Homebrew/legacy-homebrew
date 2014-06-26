require 'formula'

class Unixodbc < Formula
  homepage 'http://www.unixodbc.org/'
  url 'http://www.unixodbc.org/unixODBC-2.3.2.tar.gz'
  sha1 'f84520fd58143625b614fde551435178a558ee2e'

  bottle do
    sha1 "b57d4162ab0aae7a2b9b590c340156c2a211608a" => :mavericks
    sha1 "02dcda0fcd62483207ef664cb88a4d94e067602e" => :mountain_lion
    sha1 "d3ea697a384347cfbbaa35d3478654813b2d0978" => :lion
  end

  option :universal

  conflicts_with 'virtuoso', :because => 'Both install `isql` binaries.'

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-gui=no"
    system "make install"
  end
end
