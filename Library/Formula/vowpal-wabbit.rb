require 'formula'

class VowpalWabbit < Formula
  homepage 'https://github.com/JohnLangford/vowpal_wabbit'
  url 'https://github.com/JohnLangford/vowpal_wabbit/archive/v7.3.tar.gz'
  sha1 'aa33edcfa8264bdb45c0770b8784cb7ddcdc80e1'

  head do
    url 'https://github.com/JohnLangford/vowpal_wabbit.git'

    depends_on :libtool
    depends_on :automake
  end

  depends_on 'boost' => :build

  def install
    if build.head?
      inreplace 'autogen.sh' do |s|
        s.gsub! '/usr/share/aclocal', "#{HOMEBREW_PREFIX}/share/aclocal"
      end
      system "./autogen.sh"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
