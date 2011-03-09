require 'formula'

class Monotone <Formula
  url 'http://www.monotone.ca/downloads/0.99.1/monotone-0.99.1.tar.gz'
  homepage 'http://www.monotone.ca/'
  sha1 'e74ba571b358f6b76370f882d15ddbd1edd9f37e'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'botan'
  depends_on 'libidn'
  depends_on 'lua'
  depends_on 'pcre'

  def install
    fails_with_llvm "linker fails"

    def install_body
      system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
      system "make install"
    end

    # Monotone only needs headers from Boost (it's templates all the way down!), so let's avoid
    # building boost (which takes approximately forever) if it's not already installed. This is
    # suggested in the Monotone installation instructions.

    boost = Formula.factory('boost')
    if boost.installed?
      install_body
    else
      monotone_dir = Dir.pwd
      # a formula's stage method is private, so we cannot call boost.stage
      boost.brew do
        boost_dir = Dir.pwd
        ENV.append "CXXFLAGS", "-I"+boost_dir
        Dir.chdir monotone_dir
        install_body
      end
    end
  end
end
