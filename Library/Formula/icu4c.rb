require 'formula'

class Icu4c < Formula
  homepage 'http://site.icu-project.org/'
  url 'http://download.icu-project.org/files/icu4c/50.1/icu4c-50_1-src.tgz'
  version '50.1'
  sha1 '9a3369c00a8be8eff935d2893849ad2eb246c0ef'

  bottle do
    sha1 'a71560ffd35869a1d56cd726e02b80ff5bbf2e5b' => :mountainlion
    sha1 '0488d374c7b3cbf9c744e8b4f036e225803de20a' => :lion
    sha1 '699a9505564a37a06c485371e1ab6fb82eedafa0' => :snowleopard
  end

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
