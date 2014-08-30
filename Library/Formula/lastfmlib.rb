require 'formula'

class Lastfmlib < Formula
  homepage 'http://code.google.com/p/lastfmlib/'
  url 'https://lastfmlib.googlecode.com/files/lastfmlib-0.4.0.tar.gz'
  sha1 'b9e15e4eb42a9ccd9b3c5373054b0bd51a406fdd'

  bottle do
    cellar :any
    sha1 "eebec974f31e94d6987e108127e1ab1af606f176" => :mavericks
    sha1 "4807c28f6d74217022fd9230adee4d3ad0ca858a" => :mountain_lion
    sha1 "981967e12bb1511b82b145d17e5ac68f3aef1f5f" => :lion
  end

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
