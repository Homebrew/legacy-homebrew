class GnuGetopt < Formula
  desc "Command-line option parsing library"
  homepage "http://software.frodo.looijaard.name/getopt/"
  url "http://frodo.looijaard.name/system/files/software/getopt/getopt-1.1.6.tar.gz"
  sha256 "d0bf1dc642a993e7388a1cddfb9409bed375c21d5278056ccca3a0acd09dc5fe"

  bottle do
    sha256 "5e9e87fe18c5681e80f1cf940fed275ed895831304326bc5e7be6fb6e53e8594" => :el_capitan
    sha256 "f8dbbec03aaaeb1bc774d9bf606701901cc9a8ad15cecc5473567e51845057e6" => :yosemite
    sha256 "27938c615808c8e4ff2eacac0a4059c76dee5518a5c8bbfb304b24b70736b429" => :mavericks
    sha256 "88a02cd609a91253e9b996a1fcb1e8837161673e413fe792e5d05aa3ff9a94cf" => :mountain_lion
  end

  depends_on "gettext"

  keg_only :provided_by_osx

  def install
    inreplace "Makefile" do |s|
      gettext = Formula["gettext"]
      s.change_make_var! "CPPFLAGS", "\\1 -I#{gettext.include}"
      s.change_make_var! "LDFLAGS", "\\1 -L#{gettext.lib} -lintl"
    end
    system "make", "prefix=#{prefix}", "mandir=#{man}", "install"
  end

  test do
    system "#{bin}/getopt", "-o", "--test"
  end
end
