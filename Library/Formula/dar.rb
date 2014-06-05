require 'formula'

class Dar < Formula
  homepage 'http://dar.linux.free.fr/doc/index.html'
  url 'https://downloads.sourceforge.net/project/dar/dar/2.4.13/dar-2.4.13.tar.gz'
  sha1 'b20471ada21cd0cbe4687e7bdd3c2e6f70f5c0d1'

  bottle do
    sha1 "f940432b6ef7ef6698ff91b11ebb3f345ad56dde" => :mavericks
    sha1 "87527fd8b9ebede46f237418faff211a789dda8d" => :mountain_lion
    sha1 "9ba093a21a28e227b05f41a2938d3d18fbdbefac" => :lion
  end

  option 'with-docs', 'build programming documentation (in particular libdar API documentation) and html man page'
  option 'with-libgcrypt', 'enable strong encryption support'
  option 'with-lzo', 'enable lzo compression support'
  option 'with-upx', 'make executables compressed at installation time'

  depends_on 'coreutils' => :build if build.with? 'docs'
  depends_on 'doxygen' => :build if build.with? 'docs'
  depends_on 'gettext' => :optional
  depends_on 'gnu-sed' => :build
  depends_on 'libgcrypt' => :optional
  depends_on 'lzo' => :optional
  depends_on 'upx' => :build if build.with? 'upx'

  def install
    ENV.prepend_path 'PATH', "#{Formula['gnu-sed'].opt_prefix}/libexec/gnubin"
    ENV.prepend_path 'PATH', "#{Formula['coreutils'].libexec}/gnubin" if build.with? 'docs'
    ENV.libstdcxx if ENV.compiler == :clang && MacOS.version >= :mavericks

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-dar-static
      --prefix=#{prefix}
    ]

    args << "--disable-build-html" if build.without? 'docs'
    args << "--disable-libgcrypt-linking" if build.without? 'libgcrypt'
    args << "--disable-liblzo2-linking" if build.without? 'lzo'
    args << "--disable-upx" if build.without? 'upx'

    system "./configure", *args
    system "make install"
  end
end
