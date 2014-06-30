require 'formula'

class Dar < Formula
  homepage 'http://dar.linux.free.fr/doc/index.html'
  url 'https://downloads.sourceforge.net/project/dar/dar/2.4.14/dar-2.4.14.tar.gz'
  sha1 '77f3592cb80a70f663412ca3cb9008a51c9ca4d6'

  bottle do
    sha1 "c3602f446508944f94682e4c02236e8a7ef0801c" => :mavericks
    sha1 "2bd3dd6c9972a001d27c26499c4871d2c3489d3f" => :mountain_lion
    sha1 "dc52dcf3187c93bcf7fbabda25987499e32a116d" => :lion
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
