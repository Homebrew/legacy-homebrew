require 'formula'

def use_python?
  ARGV.include? '--enable-python-bindings'
end

class Libemu < Formula
  head 'http://git.carnivore.it/libemu.git'
  homepage 'http://libemu.carnivore.it/'

  depends_on 'pkg-config' => :build

  def options
    [["--enable-python-bindings", "Compile bindings for Python"]]
  end

  if MacOS.xcode_version >= "4.3"
    # remove the autoreconf if possible, no comment provided about why it is there
    # so we have no basis to make a decision at this point.
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    inreplace 'Makefile.am' do |s|
      # Need to fix the static location of pkgconfigpath
      s.gsub! '/usr/lib/pkgconfig/', "#{lib}/pkgconfig/"
    end
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}"]
    args << "--enable-python-bindings" if use_python?

    system "autoreconf -v -i"
    system "./configure", *args
    system "make install"
  end
end
