require 'formula'

class Mcabber < Formula
  url 'http://mcabber.com/files/mcabber-0.10.1.tar.bz2'
  homepage 'http://mcabber.com/'
  md5 'fe96beab30f535d5d6270fd1719659b4'
  head 'http://mcabber.com/hg/', :using => :hg

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'loudmouth'
  depends_on 'gpgme'
  depends_on 'libgcrypt'
  depends_on 'aspell'  => :optional if ARGV.include? '--enable-aspell'
  depends_on 'enchant' => :optional if ARGV.include? '--enable-enchant'
  depends_on 'libotr'  => :optional if ARGV.include? '--enable-otr'
  depends_on 'libidn'  => :optional

  def options
    [
      ["--enable-enchant", "Enable spell checking support via enchant"],
      ["--enable-aspell", "Enable spell checking support via aspell"],
      ["--enable-otr", "Enable support for off-the-record messages"]
    ]
  end

  def install
    system "./autogen.sh" if ARGV.build_head?
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}"]

    args << "--enable-aspell" if ARGV.include? "--enable-aspell"
    args << "--enable-enchant" if ARGV.include? "--enable-enchant"
    args << "--enable-otr" if ARGV.include? "--enable-otr"

    system "./configure", *args
    system "make install"

    (share+'mcabber').install %w[mcabberrc.example contrib]
  end
end
