require "formula"

class VowpalWabbit < Formula
  homepage "https://github.com/JohnLangford/vowpal_wabbit"
  url "https://github.com/JohnLangford/vowpal_wabbit/archive/7.6.tar.gz"
  sha1 "854f6e54568f6c2e849d43b0f6cd1cc286ec965d"

  head do
    url "https://github.com/JohnLangford/vowpal_wabbit.git"

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  depends_on "boost" => :build

  def install
    if build.head?
      inreplace "autogen.sh" do |s|
        s.gsub! "/usr/share/aclocal", "#{HOMEBREW_PREFIX}/share/aclocal"
      end
      system "./autogen.sh"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--with-boost=#{Formula['boost'].opt_prefix}"
    system "make"
    system "make install"
  end
end
