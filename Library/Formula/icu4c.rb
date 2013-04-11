require 'formula'

class Icu4c < Formula
  homepage 'http://site.icu-project.org/'
  url 'http://download.icu-project.org/files/icu4c/50.1/icu4c-50_1-src.tgz'
  version '50.1'
  sha1 '9a3369c00a8be8eff935d2893849ad2eb246c0ef'

  bottle do
    revision 2
    sha1 '34c2ab788c5ca698c1902d3d6c38db0461f8b100' => :mountain_lion
    sha1 '899afa2267843f7204583884885f2c05f8189ddc' => :lion
    sha1 'a54cbdd33dbdcb0fd8ed2441580e91e8ff114640' => :snow_leopard
  end

  keg_only "Conflicts; see: https://github.com/mxcl/homebrew/issues/issue/167"

  option :universal

  fails_with :clang do
    cause "Icu will turn on C++11 mode when built with clang, which causes incompatibilities."
  end

  def install
    ENV.universal_binary if build.universal?

    ENV.append "LDFLAGS", "-headerpad_max_install_names"
    args = ["--prefix=#{prefix}", "--disable-samples", "--disable-tests", "--enable-static"]
    args << "--with-library-bits=64" if MacOS.prefer_64_bit?
    cd "source" do
      system "./configure", *args
      system "make"
      system "make install"
    end
  end
end
