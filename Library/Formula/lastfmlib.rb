class Lastfmlib < Formula
  desc "Implements Last.fm v1.2 submissions protocol for scrobbling"
  homepage "https://code.google.com/p/lastfmlib/"
  url "https://lastfmlib.googlecode.com/files/lastfmlib-0.4.0.tar.gz"
  sha256 "28ecaffe2efecd5ac6ac00ba8e0a07b08e7fb35b45dfe384d88392ad6428309a"

  bottle do
    cellar :any
    revision 1
    sha1 "764db4a4f10b803d6fccf6552a47427634e70c18" => :yosemite
    sha1 "dcb26b1acf66e30f694543ad32f3b4433745667d" => :mavericks
    sha1 "61c0b04548eefedd3c546e3bbf392987d667c2b9" => :mountain_lion
  end

  depends_on "pkg-config" => :build

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
    system "make", "install"
  end
end
