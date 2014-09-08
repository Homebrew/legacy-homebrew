require 'formula'

class Findutils < Formula
  homepage 'http://www.gnu.org/software/findutils/'
  url 'http://ftpmirror.gnu.org/findutils/findutils-4.4.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/findutils/findutils-4.4.2.tar.gz'
  sha1 'e8dd88fa2cc58abffd0bfc1eddab9020231bb024'

  bottle do
    sha1 "aa891bdc442314c4aeb3f1a14d9b3d5ebe037332" => :mavericks
    sha1 "8c75b59f6e8e39246879f3dadca6007f7147e3f0" => :mountain_lion
    sha1 "bc7e41186d3a3610a417b4dd5fd9a874f9b21c58" => :lion
  end

  option 'default-names', "Do not prepend 'g' to the binary"

  def install
    args = ["--prefix=#{prefix}",
            "--localstatedir=#{var}/locate",
            "--disable-dependency-tracking",
            "--disable-debug"]
    args << "--program-prefix=g" unless build.include? 'default-names'

    system "./configure", *args
    system "make install"
  end
end
