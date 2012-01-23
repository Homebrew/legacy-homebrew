require 'formula'

class Icu4c < Formula
  url 'http://download.icu-project.org/files/icu4c/4.8.1.1/icu4c-4_8_1_1-src.tgz'
  homepage 'http://site.icu-project.org/'
  md5 'ea93970a0275be6b42f56953cd332c17'
  version '4.8.1.1'

  bottle do
    url 'https://downloads.sf.net/project/machomebrew/Bottles/icu4c-4.8.1.1-bottle.tar.gz'
    sha1 '51b6e6e735ea581a2736127414e600362846b7e1'
  end

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
