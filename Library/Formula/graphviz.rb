require 'formula'

class Graphviz <Formula
  url 'http://www.graphviz.org/pub/graphviz/stable/SOURCES/graphviz-2.26.3.tar.gz'
  md5 '6f45946fa622770c45609778c0a982ee'
  homepage 'http://graphviz.org/'

  depends_on 'pkg-config' => :build
  depends_on 'pango' if ARGV.include? '--with-pdf'
  depends_on 'cairo' if ARGV.include? '--with-pdf'

  def options
    [
      ["--with-pdf", "Build with Pango/Cairo to support native PDF output"],
    ]
  end

  def caveats
    s = ""
    if ARGV.include? "--with-pdf"
      s += <<-EOS.undent
        Installing with native pdf support through Pango/Cairo

      EOS
    else
      s += <<-EOS.undent
        Use --with-pdf to build with native pdf support through Pango/Cairo

      EOS
    end

    return s
  end

  def install
    ENV.x11
    # Various language bindings fail with 32/64 issues.
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-quartz",
                          "--disable-java",
                          "--disable-ocaml",
                          "--disable-perl",
                          "--disable-php",
                          "--disable-python",
                          "--disable-r",
                          "--disable-ruby",
                          "--disable-sharp",
                          "--disable-swig"
    system "make install"
  end
end
