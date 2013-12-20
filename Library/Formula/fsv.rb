require 'formula'

class Fsv < Formula
  homepage 'http://fsv.sourceforge.net/'
  url 'https://github.com/natritmeyer/fsv.git', :tag => 'v0.9.1'
  # See https://github.com/Homebrew/homebrew/pull/19161 for discussion and
  # reason about why we use this fork here. Eventually upstream at
  # 'https://github.com/mcuelenaere/fsv.git' should add tags!
  # Also note the sourceforge repo (but that seems no longer maintained.)

  depends_on :x11
  depends_on 'gtk+'
  depends_on :autoconf
  depends_on :automake
  depends_on :libtool
  depends_on 'pkg-config' => :build
  depends_on 'gtkglarea'

  def install
    inreplace 'autogen.sh' do |s|
      s.gsub! 'libtoolize', 'glibtoolize'
    end

    inreplace 'configure.in' do |s|
      s.gsub! 'AM_CONFIG_HEADER', 'AC_CONFIG_HEADERS'
    end

    system "sh", "autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
