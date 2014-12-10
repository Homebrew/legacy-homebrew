require 'formula'

class Libcroco < Formula
  homepage 'http://www.linuxfromscratch.org/blfs/view/svn/general/libcroco.html'
  url 'http://ftp.gnome.org/pub/GNOME/sources/libcroco/0.6/libcroco-0.6.5.tar.xz'
  sha256 '2c6959c3644e889264a61c35ddf17401c86943681d4fe3c1682ecd9acabda7e3'

  bottle do
    cellar :any
    revision 1
    sha1 "055cf72538ad7dc86cec135bf207347cfb6c4111" => :yosemite
    sha1 "33f4e055880495f080be7253315c5adb064e7dd7" => :mavericks
    sha1 "52cd96351c6cbdce21f396823813b79dd60c4f09" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'glib'

  def install
    ENV.libxml2
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-Bsymbolic"
    system 'make install'
  end
end
