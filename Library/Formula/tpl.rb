require "formula"

class Tpl < Formula
  homepage "http://troydhanson.github.io/tpl/"
  url "https://github.com/troydhanson/tpl/archive/v1.6.tar.gz"
  sha1 "b7d16e9bcda16d86a5dd2d0af0ab90f7e85aa050"
  head "https://github.com/troydhanson/tpl.git"

  option 'with-tests', 'Verify the build using the test suite.'

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool

  def install
    inreplace 'configure.ac' do |s|
      s.gsub! "AM_INIT_AUTOMAKE", "AM_INIT_AUTOMAKE([foreign])"
    end

    system "autoreconf -i"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    if build.include? 'tests'
      cd "tests" do
        system "make"
      end
    end
  end
end
