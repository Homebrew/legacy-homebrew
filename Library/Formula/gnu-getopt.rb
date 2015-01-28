class GnuGetopt < Formula
  homepage "http://software.frodo.looijaard.name/getopt/"
  url "http://frodo.looijaard.name/system/files/software/getopt/getopt-1.1.5.tar.gz"
  sha1 "9090eb46ac92f2fd2749ca4121e81aaad40f325d"

  bottle do
    revision 1
    sha1 "003e06f4580de4066f39bf7d4c178f3e06e1b55a" => :yosemite
    sha1 "a694925a2dce22c7bbbd252907b8e484e9a1db39" => :mavericks
    sha1 "8c90689aca391072d2a557b8f8ebfe0eacbba2f2" => :mountain_lion
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
