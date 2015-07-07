require 'formula'

class Arabica < Formula
  desc "XML toolkit written in C++"
  homepage 'http://www.jezuk.co.uk/cgi-bin/view/arabica'
  url 'https://downloads.sourceforge.net/project/arabica/arabica/November-12/arabica-2012-November.tar.gz'
  version '20121126'
  sha1 '34d043607e048e0972a57e31bfff09086d893d14'

  head do
    url 'https://github.com/jezhiggins/arabica.git'

    depends_on 'autoconf' => :build
    depends_on 'automake' => :build
    depends_on 'libtool' => :build
  end

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
