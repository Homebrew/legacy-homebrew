require 'formula'

class Icu4c < Formula
  url 'http://download.icu-project.org/files/icu4c/4.8.1/icu4c-4_8_1-src.tgz'
  homepage 'http://site.icu-project.org/'
  md5 'af36f635271a239d76d038d6cf8da8df'
  version "4.8.1"

  bottle 'https://downloads.sf.net/project/machomebrew/Bottles/icu4c-4.8.1-bottle.tar.gz'
  bottle_sha1 '71729c0bda0a440959be2e395f911b5e591d6ea3'

  keg_only "Conflicts; see: https://github.com/mxcl/homebrew/issues/issue/167"

  def install
    ENV.append "LDFLAGS", "-headerpad_max_install_names"
    config_flags = ["--prefix=#{prefix}", "--disable-samples", "--enable-static"]
    config_flags << "--with-library-bits=64" if MacOS.prefer_64_bit?
    Dir.chdir "source" do
      system "./configure", *config_flags
      system "make"
      system "make install"
    end
  end
end
