require 'formula'

class Stderred < Formula
  homepage 'https://github.com/sickill/stderred'
  url 'https://github.com/sickill/stderred/archive/v1.0.zip'
  sha1 'b4a0c9caa49ecd09407ac708c3ec895cde6d7711'

  depends_on 'cmake' => :build

  def install
    system "make", "universal"
    prefix.install "build/libpolyfill.dylib"
    prefix.install "build/libstderred.dylib"
    prefix.install "build/libtest_stderred.dylib"
  end

  def caveats; <<-EOS.undent
    To enable stderred, you need to add the full path to its
    library to the DYLD_INSERT_LIBRARIES environment variable.

    You can do so by adding these lines in you shell init
    script (~/.bashrc or .zshrc):

      if [ -f #{prefix}/libstderred.dylib ]
      then
        export DYLD_INSERT_LIBRARIES="#{prefix}/libstderred.dylib${DYLD_INSERT_LIBRARIES:+:$DYLD_INSERT_LIBRARIES}"
      else
        echo "stderred library not found." >&2
      fi

    Don't forget to remove these if you uninstall stderred.

    IMPORTANT: after uninstalling you either restart your shell or run:
      unset DYLD_INSERT_LIBRARIES
    EOS
  end
end
