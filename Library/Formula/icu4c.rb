require 'formula'

class Icu4c < Formula
  url 'http://download.icu-project.org/files/icu4c/4.8.1.1/icu4c-4_8_1_1-src.tgz'
  homepage 'http://site.icu-project.org/'
  md5 'ea93970a0275be6b42f56953cd332c17'
  version '4.8.1.1'

  bottle 'https://downloads.sf.net/project/machomebrew/Bottles/icu4c-4.8.1.1-bottle.tar.gz'
  bottle_sha1 'a4a5eb012eab4adeb3ad87734628a3aa8ca7dcc2'

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
