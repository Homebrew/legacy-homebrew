require 'formula'

class Znc < Formula
  homepage 'http://wiki.znc.in/ZNC'
  url 'http://znc.in/releases/archive/znc-1.0.tar.gz'
  sha1 '50e6e3aacb67cf0a63d77f5031d4b75264cee294'

  head 'https://github.com/znc/znc.git'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'pkg-config' => :build
  depends_on 'c-ares' => :optional

  skip_clean 'bin/znc'
  skip_clean 'bin/znc-config'
  skip_clean 'bin/znc-buildmod'

  option 'enable-debug', "Compile ZNC with --enable-debug"

  def install
    args = ["--prefix=#{prefix}", "--enable-extra"]
    args << "--enable-debug" if build.include? 'enable-debug'

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make install"
  end
end
