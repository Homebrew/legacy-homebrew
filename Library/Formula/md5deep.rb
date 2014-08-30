require 'formula'

class Md5deep < Formula
  homepage 'https://github.com/jessek/hashdeep'
  url 'https://github.com/jessek/hashdeep/archive/release-4.4.tar.gz'
  sha1 'cb4e313352974299c32bc55fe56396adb74517ef'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build

  def install
    system "sh bootstrap.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system bin/"md5deep", "-h"
    system bin/"hashdeep", "-h"
  end
end
