require 'formula'

class PltRacket < Formula
  homepage 'http://racket-lang.org/'
  url 'https://github.com/plt/racket/archive/v5.3.6.tar.gz'
  sha1 '6b0e7a11bb3ae6480b99db346e5b503a97539e6b'

  depends_on :macos => :mountain_lion # https://github.com/Homebrew/homebrew/pull/22420

  depends_on 'glib'
  depends_on 'cairo'
  depends_on 'pango'
  depends_on 'jpeg'
  depends_on 'gtk+'
  depends_on 'gmp'
  depends_on 'mpfr'

  option 'without-docs', 'Don’t build documentation. (saves around 150 MB)'

  def install
    cd 'src' do
      args = ["--disable-debug", "--disable-dependency-tracking",
              "--enable-xonx",
              "--prefix=#{prefix}" ]

      args << '--disable-mac64' if not MacOS.prefer_64_bit?

      args << '--disable-docs' if build.include? 'without-docs'

      # There's a mysterious error that afflicts non-Mavericks users. The
      # problem seems to disappear if we deparallelize the `raco` process.
      ENV['PLT_SETUP_OPTIONS'] = '--workers 1'

      system "./configure", *args
      system "make"
      system "make install"
    end
  end

  test do
    # Make sure the GUI-related dynamic libraries are available.
    system bin/'racket', '--eval', '(require ffi/unsafe) (or (ffi-lib "libcairo") (exit 1))'
    system bin/'racket', '--eval', '(require ffi/unsafe) (or (ffi-lib "libffi") (exit 1))'
    system bin/'racket', '--eval', '(require ffi/unsafe) (or (ffi-lib "libgio-2.0") (exit 1))'
    system bin/'racket', '--eval', '(require ffi/unsafe) (or (ffi-lib "libjpeg") (exit 1))'
    system bin/'racket', '--eval', '(require ffi/unsafe) (or (ffi-lib "libglib-2.0") (exit 1))'
    system bin/'racket', '--eval', '(require ffi/unsafe) (or (ffi-lib "libpango-1.0") (exit 1))'
    system bin/'racket', '--eval', '(require ffi/unsafe) (or (ffi-lib "libgmodule-2.0") (exit 1))'
    system bin/'racket', '--eval', '(require ffi/unsafe) (or (ffi-lib "libpangocairo-1.0") (exit 1))'
    system bin/'racket', '--eval', '(require ffi/unsafe) (or (ffi-lib "libgobject-2.0") (exit 1))'
    system bin/'racket', '--eval', '(require ffi/unsafe) (or (ffi-lib "libpixman-1") (exit 1))'
    system bin/'racket', '--eval', '(require ffi/unsafe) (or (ffi-lib "libgthread-2.0") (exit 1))'
    system bin/'racket', '--eval', '(require ffi/unsafe) (or (ffi-lib "libpng15") (exit 1))'

    # Make sure the math-related dynamic libraries are available.
    system bin/'racket', '--eval', '(require ffi/unsafe) (or (ffi-lib "libgmp") (exit 1))'
    system bin/'racket', '--eval', '(require ffi/unsafe) (or (ffi-lib "libmpfr") (exit 1))'
  end

  def caveats; <<-EOS.undent
    If you want to use the DrRacket IDE, we recommend that you use
    the PLT-provided packages from http://racket-lang.org/download/.
    EOS
  end
end
