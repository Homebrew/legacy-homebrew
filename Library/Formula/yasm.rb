require 'formula'

class Yasm < Formula
  homepage 'http://yasm.tortall.net/'
  url 'http://tortall.net/projects/yasm/releases/yasm-1.2.0.tar.gz'
  sha256 '768ffab457b90a20a6d895c39749adb547c1b7cb5c108e84b151a838a23ccf31'

  bottle do
    cellar :any
    sha1 "cd4b87a7ab1a80b4461b6b21f4a51e98186a225e" => :mavericks
    sha1 "adf3e0d26dbb17a37c310d7bdf8821d54a4f5914" => :mountain_lion
    sha1 "b5f60c20bd5e5b475d982f994f3754f07e63674f" => :lion
  end

  head do
    url 'https://github.com/yasm/yasm.git'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext"
  end

  depends_on :python => :optional
  depends_on 'Cython' => :python if build.with? 'python'

  def install
    # https://github.com/Homebrew/homebrew/pull/19593
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
end
