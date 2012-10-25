require 'formula'

class VowpalWabbit < Formula
  homepage 'https://github.com/JohnLangford/vowpal_wabbit'
  url 'https://github.com/JohnLangford/vowpal_wabbit/tarball/v7.0'
  sha1 '1960f9b8423ce13d6c0f29e3c23feeb2d52f2918'

  head 'git://github.com/JohnLangford/vowpal_wabbit.git'

  depends_on :libtool
  depends_on :automake
  depends_on 'boost' => :build

  def install
    # 7.0 tarball doesn't include autogen files
    inreplace 'autogen.sh' do |s|
      s.gsub! 'libtoolize', 'glibtoolize'
      s.gsub! '/usr/share/aclocal', "#{HOMEBREW_PREFIX}/share/aclocal"
    end

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
