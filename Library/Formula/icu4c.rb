require 'formula'

class Icu4c < Formula
  homepage 'http://site.icu-project.org/'
  url 'http://download.icu-project.org/files/icu4c/51.1/icu4c-51_1-src.tgz'
  version '51.1'
  sha1 '7905632335e3dcd6667224da0fa087b49f9095e9'

  bottle do
    sha1 '6b5b4ab5704cc2a8b17070a087c7f9594466cf1d' => :mountain_lion
    sha1 'a555b051a65717e1ca731eec5743969d8190a9f8' => :lion
    sha1 'bcb1ab988f67c3d48fb7c5829153c136c16c059b' => :snow_leopard
  end

  keg_only "Conflicts; see: https://github.com/mxcl/homebrew/issues/issue/167"

  option :universal

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
