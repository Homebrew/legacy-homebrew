require 'formula'

def build_bindings?
  ARGV.include? '--python'
end

class Ldns < Formula
  homepage 'http://nlnetlabs.nl/projects/ldns/'
  url 'http://nlnetlabs.nl/downloads/ldns/ldns-1.6.12.tar.gz'
  sha1 '1d61df0f666908551d5a62768f77d63e727810aa'

  depends_on 'swig' if build_bindings?

  def options
    [["--python", "Build Python pydns bindings"]]
  end

  def install
    args = ["--prefix=#{prefix}", "--disable-gost", "--with-drill", "--with-examples"]
    args << "--with-pyldns" if build_bindings?
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"
    system "./configure", *args
    system "make"
    system "make install"
    system "make install-pyldns" if build_bindings?
  end
end
