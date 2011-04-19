require 'formula'

class Libxml2 < Formula
  url 'ftp://xmlsoft.org/libxml2/libxml2-2.7.8.tar.gz'
  homepage 'http://xmlsoft.org'
  md5 '8127a65e8c3b08856093099b52599c86'

  keg_only :provided_by_osx

  fails_with_llvm "Undefined symbols when linking", :build => "2326"

  def options
    [['--with-python', 'Compile the libxml2 Python 2.x modules']]
  end

  def install
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]

    if ARGV.include? '--with-python'
      python_prefix=`python-config --prefix`
      ohai "Installing Python module to #{python_prefix}"
      args << "--with-python=#{python_prefix}"
    end

    system "./configure", *args
    system "make"
    ENV.j1
    system "make install"
  end
end
