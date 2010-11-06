require 'formula'

class Libcaca <Formula
  url 'http://caca.zoy.org/files/libcaca/libcaca-0.99.beta17.tar.gz'
  version '0.99b17'
  homepage 'http://caca.zoy.org/wiki/libcaca'
  md5 '790d6e26b7950e15909fdbeb23a7ea87'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'

  def install
    # Some people can't compile when Java is enabled. See:
    # http://github.com/mxcl/homebrew/issues/issue/2049

    # Don't build csharp bindings
    # Don't build ruby bindings; fails for adamv w/ Homebrew Ruby 1.9.2

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-imlib2",
                          "--disable-doc",
                          "--disable-slang",
                          "--disable-java",
                          "--disable-csharp",
                          "--disable-ruby"
    ENV.j1 # Or install can fail making the same folder at the same time
    system "make install"
  end
end
