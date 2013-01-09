require 'formula'

class VowpalWabbit < Formula
  homepage 'https://github.com/JohnLangford/vowpal_wabbit'
  url 'https://github.com/JohnLangford/vowpal_wabbit/tarball/v7.1'
  sha1 'a2a8241654d79fd2c0b14a3907d98f7e87705ba8'

  head 'https://github.com/JohnLangford/vowpal_wabbit.git'

  if build.head?
    depends_on :libtool
    depends_on :automake
  end

  depends_on 'boost' => :build

  def install
    if build.head?
      inreplace 'autogen.sh' do |s|
        s.gsub! 'libtoolize', 'glibtoolize'
        s.gsub! '/usr/share/aclocal', "#{HOMEBREW_PREFIX}/share/aclocal"
      end
      system "./autogen.sh"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
