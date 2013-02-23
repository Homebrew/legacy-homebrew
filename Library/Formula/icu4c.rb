require 'formula'

class Icu4c < Formula
  homepage 'http://site.icu-project.org/'
  url 'http://download.icu-project.org/files/icu4c/50.1/icu4c-50_1-src.tgz'
  version '50.1'
  sha1 '9a3369c00a8be8eff935d2893849ad2eb246c0ef'

  bottle do
<<<<<<< HEAD
<<<<<<< HEAD
=======
    sha1 '9e424ea5de5c5847b8a600078f9494f42d7f6168' => :mountainlion
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
    sha1 '528b8bec1b821d5503eb98b565840d8a3aeca63e' => :lion
    sha1 'c77579349187ee0cec5842f71aea2a446c770db7' => :snowleopard
=======
    version 1
    sha1 '0ec81beb069eeea0e3c2fb5a1193607084de2a7f' => :mountainlion
    sha1 '280d2010c9f467a849366b0b20e5368297333afd' => :lion
    sha1 '3789775bb60069eb62abc972d63c7f3baffe2883' => :snowleopard
>>>>>>> 35b0414670cc73c4050f911c89fc1602fa6a1d40
  end

  keg_only "Conflicts; see: https://github.com/mxcl/homebrew/issues/issue/167"

  option :universal

  fails_with :clang do
    build 425
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
