require 'formula'

class Gaupol < Formula
  homepage 'http://home.gna.org/gaupol/'
  url 'http://download.gna.org/gaupol/0.19/gaupol-0.19.2.tar.gz'
  sha1 'cf11f5c4fddba3e1848bfacdabe99b9a963f9f7c'

  depends_on 'intltool' => :build
  depends_on :x11
  depends_on :python
  depends_on 'gettext'

  def install
    system "./setup.py", "clean", "install", "--prefix=#{prefix}"
  end

  test do
    system "gaupol -v"
  end
end
