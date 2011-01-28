require 'formula'

class Libxslt <Formula
  url 'ftp://xmlsoft.org/libxml2/libxslt-1.1.26.tar.gz'
  homepage 'http://xmlsoft.org'
  md5 'e61d0364a30146aaa3001296f853b2b9'

  keg_only :provided_by_osx

  def options
    # Works with the Python 2 formula
    [['--with-python', 'Compile the libxslt Python 2.x modules']]
  end

  def install
    fails_with_llvm "Undefined symbols when linking", :build => "2326"

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
