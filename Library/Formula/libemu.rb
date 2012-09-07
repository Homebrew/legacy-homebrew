require 'formula'

class Libemu < Formula
  head 'http://git.carnivore.it/libemu.git'
  homepage 'http://libemu.carnivore.it/'

  option "enable-python-bindings", "Compile bindings for Python"

  depends_on 'pkg-config' => :build
  depends_on :automake
  depends_on :libtool

  def install
    inreplace 'Makefile.am' do |s|
      # Need to fix the static location of pkgconfigpath
      s.gsub! '/usr/lib/pkgconfig/', "#{lib}/pkgconfig/"
    end
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << "--enable-python-bindings" if build.include? 'enable-python-bindings'

    system "autoreconf -v -i"
    system "./configure", *args
    system "make install"
  end
end
