class Itstool < Formula
  desc "Make XML documents translatable through PO files"
  homepage "http://itstool.org/"
  url "http://files.itstool.org/itstool/itstool-2.0.2.tar.bz2"
  sha256 "bf909fb59b11a646681a8534d5700fec99be83bb2c57badf8c1844512227033a"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "4bbeea37b4f8f887458ffae502c74306a931ffbda43c34ae0f05eb5011dffd28" => :el_capitan
    sha256 "22b1b0163b35b35fefbea27321cea0359dba726b832cf892729825ff718add6e" => :yosemite
    sha256 "e8e0dbf50b44a058553bc63d039809cc1d96efb8c8a8c73b5e6f9f10b568d644" => :mavericks
  end

  head do
    url "https://github.com/itstool/itstool.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libxml2" => "with-python"

  def install
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"

    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{libexec}"
    system "make", "install"

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    pkgshare.install_symlink libexec/"share/itstool/its"
    man1.install_symlink libexec/"share/man/man1/itstool.1"
  end

  test do
    (testpath/"test.xml").write <<-EOS.undent
      <tag>Homebrew</tag>
    EOS
    system bin/"itstool", "-o", "test.pot", "test.xml"
    assert_match "msgid \"Homebrew\"", File.read("test.pot")
  end
end
