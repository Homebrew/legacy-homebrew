require 'formula'

class Cpptest < Formula
  homepage 'http://cpptest.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/cpptest/cpptest/cpptest-1.1.2/cpptest-1.1.2.tar.gz'
  sha1 'c8e69ca98f9b39016c94f1f78659f412ee825049'

  bottle do
    cellar :any
    sha1 "f2133e40791ea80673b2fc1af5025bafcabbf7ea" => :mavericks
    sha1 "411e68bba4a50be0a6f77b02084fc1a04380d500" => :mountain_lion
    sha1 "3f84ffdd46df62b000f5c6c14aa7f43a5c046fef" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
