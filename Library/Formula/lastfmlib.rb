require 'formula'

class Lastfmlib < Formula
  homepage 'http://code.google.com/p/lastfmlib/'
  url 'https://lastfmlib.googlecode.com/files/lastfmlib-0.4.0.tar.gz'
  sha1 'b9e15e4eb42a9ccd9b3c5373054b0bd51a406fdd'

  depends_on 'pkg-config' => :build

  fails_with :clang do
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
