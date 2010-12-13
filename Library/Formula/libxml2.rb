require 'formula'

class Libxml2 <Formula
  url 'ftp://xmlsoft.org/libxml2/libxml2-2.7.7.tar.gz'
  homepage 'http://xmlsoft.org'
  md5 '9abc9959823ca9ff904f1fbcf21df066'

  keg_only :provided_by_osx

  def options
    # Works with the Python 2 formula
    [['--with-python', 'Compile the libxml2 Python 2.x modules']]
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
