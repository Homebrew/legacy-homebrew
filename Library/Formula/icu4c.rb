require 'formula'

class Icu4c < Formula
  homepage 'http://site.icu-project.org/'
  url 'http://download.icu-project.org/files/icu4c/49.1.2/icu4c-49_1_2-src.tgz'
  version '49.1.2'
  md5 'bbc609fe5237202d7abf016141012a45'

  keg_only "Conflicts; see: https://github.com/mxcl/homebrew/issues/issue/167"

  def options
    [
      ["--universal", "Build universal binaries."]
    ]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?

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
