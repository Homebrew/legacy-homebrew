require 'formula'

class Monotone < Formula
  homepage 'http://monotone.ca/'
  url 'http://www.monotone.ca/downloads/1.0/monotone-1.0.tar.bz2'
  sha1 'aac556bb26d92910b74b65450a0be6c5045e2052'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'botan'
  depends_on 'libidn'
  depends_on 'lua'
  depends_on 'pcre'

  fails_with_llvm "linker fails"

  def install
    # Monotone only needs headers from Boost (it's templates all the way down!), so let's avoid
    # building boost (which takes approximately forever) if it's not already installed.
    # This is suggested in the Monotone installation instructions.

    boost = Formula.factory('boost')
    unless boost.installed?
      # Add header location to CPPFLAGS
      boost.brew { ENV.append "CXXFLAGS", "-I"+Dir.pwd }
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
