require 'formula'

class Icu4c < Formula
  homepage 'http://site.icu-project.org/'
  url 'http://download.icu-project.org/files/icu4c/49.1.2/icu4c-49_1_2-src.tgz'
  version '49.1.2'
  md5 'bbc609fe5237202d7abf016141012a45'

  bottle do
    sha1 '9e424ea5de5c5847b8a600078f9494f42d7f6168' => :mountainlion
    sha1 '528b8bec1b821d5503eb98b565840d8a3aeca63e' => :lion
    sha1 'c77579349187ee0cec5842f71aea2a446c770db7' => :snowleopard
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
