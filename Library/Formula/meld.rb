require 'formula'

class Meld < Formula
  homepage 'http://meldmerge.org'
  url 'http://ftp.gnome.org/pub/GNOME/sources/meld/1.6/meld-1.6.0.tar.xz'
  sha256 'a0ec4e19e85ea4df0214da4c92a4069095d37a252ab240fc1bc00f29a627fea8'

  depends_on 'intltool' => :build
  depends_on 'xz' => :build
  depends_on 'pygtk'
  depends_on 'pygobject'
  depends_on 'rarian'

  def install
    system "make", "prefix=#{prefix}", "install"
  end
end
