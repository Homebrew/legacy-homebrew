require 'formula'

class Libxslt < Formula
  url 'ftp://xmlsoft.org/libxml2/libxslt-1.1.26.tar.gz'
  homepage 'http://xmlsoft.org/XSLT/'
  md5 'e61d0364a30146aaa3001296f853b2b9'

  keg_only :provided_by_osx

  depends_on 'libxml2'

  def options
    [
      ["--32-bit", "Build 32-bit only."]
    ]
  end

  def install
    args = ["--prefix=#{prefix}",
            "--disable-dependency-tracking",
            "--with-libxml-prefix=#{Formula.factory('libxml2').prefix}"
          ]

    if ! MacOS.prefer_64_bit? || ARGV.build_32_bit?
      ENV.append_to_cflags '-arch i386 -m32'
      args << "--build=none-apple-darwin"
    end

    system "./configure", *args
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    To allow the nokogiri gem to link against this libxslt, run

        gem install nokogiri -- --with-xslt-dir=#{prefix}
    EOS
  end
end
