require 'formula'

class Mono <Formula
  url "git://github.com/mono/mono.git", :tag => "mono-2-6-7"
  head "git://github.com/mono/mono.git"
  homepage "http://mono-project.com/"
  version "2.6.7"
  md5 ""

  depends_on "pkg-config"

  def install
    system "./autogen.sh", "--prefix=#{prefix}",
                           "--with-glib=embedded",
                           "--enable-nls=no"
    system "make"
    system "make install"
  end
end