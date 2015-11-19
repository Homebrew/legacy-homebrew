class Lastfmlib < Formula
  desc "Implements Last.fm v1.2 submissions protocol for scrobbling"
  homepage "https://code.google.com/p/lastfmlib/"
  url "https://lastfmlib.googlecode.com/files/lastfmlib-0.4.0.tar.gz"
  sha256 "28ecaffe2efecd5ac6ac00ba8e0a07b08e7fb35b45dfe384d88392ad6428309a"

  bottle do
    cellar :any
    revision 1
    sha256 "1d8ab109ccf48af2f959cee60a5db53342b54413b655217cca649532df644b03" => :yosemite
    sha256 "7ca7a69ac77d521badefc24f656a2dfde70998b32aec67c5f1fd836582ba7ab2" => :mavericks
    sha256 "6f5219ee8f973b6275cdd5c3a1fed9cfffe6e1d99a05a6ec35881a0e3317c02b" => :mountain_lion
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
