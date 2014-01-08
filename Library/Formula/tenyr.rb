require 'formula'

class Tenyr < Formula
  homepage 'http://tenyr.info/'
  url 'https://github.com/kulp/tenyr/archive/v0.5.0.tar.gz'
  sha1 '90b2ef38c25c9d35a9114c28994655b81466f466'

  head 'https://github.com/kulp/tenyr.git'

  depends_on 'bison' # tenyr requires bison >= 2.5

  def install
    system "make"
    bin.install 'tsim', 'tas', 'tld'
  end
end
