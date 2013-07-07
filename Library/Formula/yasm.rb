require 'formula'

class Yasm < Formula
  homepage 'http://yasm.tortall.net/'
  url 'http://tortall.net/projects/yasm/releases/yasm-1.2.0.tar.gz'
  sha256 '768ffab457b90a20a6d895c39749adb547c1b7cb5c108e84b151a838a23ccf31'

  head 'https://github.com/yasm/yasm.git'

  if build.head?
    depends_on 'gettext'
    depends_on :automake
  end

  depends_on :python => :optional
  depends_on 'Cython' => :python if build.with? 'python'

  def install
    # https://github.com/mxcl/homebrew/pull/19593
    ENV.deparallelize
    args = %W[
      --disable-debug
      --prefix=#{prefix}
    ]

    if build.with? 'python'
      args << '--enable-python'
      args << '--enable-python-bindings'
    end

    system './autogen.sh' if build.head?
    system './configure', *args
    system 'make install'
  end

  def caveats
    python.standard_caveats if python
  end

end
