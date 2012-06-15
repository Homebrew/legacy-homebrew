require 'formula'

class Lastfmlib < Formula
  url 'http://lastfmlib.googlecode.com/files/lastfmlib-0.4.0.tar.gz'
  homepage 'http://code.google.com/p/lastfmlib/'
  md5 'f6f00882c15b8cc703718d22e1b1871f'

  depends_on 'pkg-config' => :build

  fails_with :clang do
    build 318
    cause <<-EOS.undent
      lastfmlib/utils/stringoperations.h:62:16: error: no viable conversion from
            '__string_type' (aka 'basic_string<wchar_t, std::char_traits<wchar_t>,
            std::allocator<wchar_t> >') to 'std::string' (aka 'basic_string<char>')
      EOS
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
