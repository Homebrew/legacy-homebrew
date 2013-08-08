require 'formula'

class Znc < Formula
  homepage 'http://wiki.znc.in/ZNC'
  head 'https://github.com/znc/znc.git'
  url 'http://znc.in/releases/archive/znc-1.0.tar.gz'
  sha1 '50e6e3aacb67cf0a63d77f5031d4b75264cee294'

  option 'enable-debug', "Compile ZNC with --enable-debug"

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'pkg-config' => :build

  def install
    args = ["--prefix=#{prefix}"]
    args << "--enable-debug" if build.include? 'enable-debug'

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make install"
  end
end
