require 'formula'

class Moreutils < Formula
  homepage 'http://packages.debian.org/unstable/utils/moreutils'
  url 'http://mirrors.kernel.org/debian/pool/main/m/moreutils/moreutils_0.51.tar.gz'
  mirror 'http://ftp.us.debian.org/debian/pool/main/m/moreutils/moreutils_0.51.tar.gz'
  sha1 '374b8c3bea962bbcde4a8158051c570a1fec6811'

  bottle do
    cellar :any
    sha1 "21fa332179c54179b9581ec1fd5eae00eefbf9da" => :mavericks
    sha1 "b7b88be54b3cd5659a720dd899ceacd790414e20" => :mountain_lion
    sha1 "f873a5e0b83b859899c98126871d0fa4bb04b8b9" => :lion
  end

  depends_on "docbook-xsl" => :build

  conflicts_with 'parallel',
    :because => "both install a 'parallel' executable."

  conflicts_with 'task-spooler',
    :because => "both install a 'ts' executable."

  def install
    inreplace "Makefile",
              "/usr/share/xml/docbook/stylesheet/docbook-xsl",
              Formula["docbook-xsl"].opt_prefix/"docbook-xsl"
    system "make", "all"
    system "make", "check"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
