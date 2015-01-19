require 'formula'

class Gauche < Formula
  homepage 'http://practical-scheme.net/gauche/'
  url 'https://downloads.sourceforge.net/gauche/Gauche/Gauche-0.9.4.tgz'
  sha1 '2f0068d19adbc8e7fd3c04ab8e6576d0fac21ad6'

  bottle do
    sha1 "844ce90625ae0fd6ab27afc965edc7c05e6d283d" => :mavericks
    sha1 "e039cf0ff8ab34db5053fe2a010822ec3205b5e3" => :mountain_lion
    sha1 "087b1f85a18485fe2226892d9b96066a027de606" => :lion
  end

  option "with-slib", "Configure Gauche's slib module"

  def install
    args = ["--prefix=#{prefix}",
            '--disable-dependency-tracking',
            '--enable-multibyte=utf-8']

    args << '--with-slib=/usr/local/lib/slib' if build.with? 'slib'

    system './configure', *args
    system "make"
    system "make check"
    system "make install"
  end

  test do
    result = `#{bin}/gosh -q -E 'display (gauche-version)' -E 'exit'`
    assert_equal '0.9.4', result
  end
end
