class Veclibfort < Formula
  desc "Gnu Fortran interface to Accelerate/vecLib"
  homepage "https://github.com/mcg1969/vecLibFort"
  url "https://github.com/mcg1969/vecLibFort/archive/0.4.2.tar.gz"
  sha256 "c61316632bffa1c76e3c7f92b11c9def4b6f41973ecf9e124d68de6ae37fbc85"
  head "https://github.com/mcg1969/vecLibFort.git"
  revision 2

  bottle do
    cellar :any
    sha256 "e981968fc514cbccfa297059be14bab5f75cf769a2da51a571c6c737e5a77a02" => :yosemite
    sha256 "3260bc42e14b071a2b02b482baed8443b35835972b5edbbae9903864cb164fee" => :mavericks
    sha256 "7fa568f525a34092d731ebdcc181636f9e733a2716dc42b51a94d01182b359ee" => :mountain_lion
  end

  option "without-check", "Skip build-time tests (not recommended)"

  depends_on :fortran

  def install
    ENV.m64 if MacOS.prefer_64_bit?
    system "make", "all"
    system "make", "check" if build.with? "check"
    system "make", "PREFIX=#{prefix}", "install"
  end

  def caveats
    <<-EOS.undent
      Installs the following files:
        * libvecLibFort.a: static library; link with -framework vecLib
        * libvecLibFort.dylib: dynamic library; *replaces* -framework vecLib
        * libvecLibFortI.dylib: preload (interpose) library.
      Please see the home page for usage details.
    EOS
  end
end
