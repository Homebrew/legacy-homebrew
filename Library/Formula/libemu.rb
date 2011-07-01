require 'formula'

def use_python?
  ARGV.include? '--enable-python-bindings'
end

class Libemu < Formula
  head 'http://git.carnivore.it/libemu.git', :using => :git
  homepage 'http://libemu.carnivore.it/'

  depends_on 'pkg-config' => :build

  def options
    [["--enable-python-bindings", "Compile bindings for Python"]]
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
