require 'formula'

class Gdbm < Formula
  homepage 'http://www.gnu.org/software/gdbm/'
  url 'http://ftpmirror.gnu.org/gdbm/gdbm-1.11.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/gdbm/gdbm-1.11.tar.gz'
  sha1 'ce433d0f192c21d41089458ca5c8294efe9806b4'

  bottle do
    cellar :any
    sha1 "8d6f002454ffe4ea8332fa10a9f91be45c5ba34c" => :mavericks
    sha1 "5473f06f355c17825f388a0bf4717905b209ce2e" => :mountain_lion
    sha1 "bbce3c28c939be838375a99fa965e488d4186b2a" => :lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make install"
  end
end
