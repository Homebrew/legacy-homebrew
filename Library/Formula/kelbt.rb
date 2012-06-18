require 'formula'

class Kelbt < Formula
  homepage 'http://www.complang.org/kelbt/'
  url 'http://www.complang.org/kelbt/kelbt-0.15.tar.gz'
  sha1 '93b8e839b85ebd4ba99a8b8a0565a73d8e8bcaa1'

  # kelbt-0.15 is the final release.  So this error will be unreported, though
  # it works well using llvm or gcc.  The dev's new project similar to this
  # is called colm.  See the homepage for more info.
  fails_with :clang do
    build 318
    cause 'Undeclared identifiers'
  end

  def install
    system './configure', "--prefix=#{prefix}"
    system "make install"
  end
end
