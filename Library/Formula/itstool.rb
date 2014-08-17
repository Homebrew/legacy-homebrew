require 'formula'

class Itstool < Formula
  homepage 'http://itstool.org/'
  url 'http://files.itstool.org/itstool/itstool-2.0.2.tar.bz2'
  sha256 'bf909fb59b11a646681a8534d5700fec99be83bb2c57badf8c1844512227033a'

  head do
    url 'git://gitorious.org/itstool/itstool.git'

    depends_on :autoconf
    depends_on :automake
  end

  depends_on :python
  depends_on 'libxml2' => 'with-python'

  def install
    ENV.append_path 'PYTHONPATH', "#{Formula["libxml2"].lib}/python2.7/site-packages"

    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
