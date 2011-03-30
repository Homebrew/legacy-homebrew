require 'formula'

class Monotone < Formula
  homepage 'http://monotone.ca/'
  url 'http://www.monotone.ca/downloads/1.0/monotone-1.0.tar.bz2'
  sha1 '7f82e1c1e852005b7f7de93c8892e371869ea418'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'botan'
  depends_on 'libidn'
  depends_on 'lua'
  depends_on 'pcre'

  fails_with_llvm "linker fails"

  def install
    # Monotone only needs headers from Boost (it's templates all the way down!), so let's avoid
    # building boost (which takes approximately forever) if it's not already installed. This is
    # suggested in the Monotone installation instructions.

    boost = Formula.factory('boost')
    unless boost.installed?
      # a formula's stage method is private, so we cannot call boost.stage
      boost.brew do
        ENV.append "CXXFLAGS", "-I"+Dir.pwd
      end
    end

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
