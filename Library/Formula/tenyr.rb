require 'formula'

class Tenyr < Formula
  homepage 'https://github.com/kulp/tenyr'
  url 'https://github.com/kulp/tenyr/archive/v0.5.0.tar.gz'
  sha1 '90b2ef38c25c9d35a9114c28994655b81466f466'

  head 'https://github.com/kulp/tenyr.git'

  depends_on 'flex'
  depends_on 'bison'

  def install
    system "make"
    bin.install('tsim')
    bin.install('tas')
    bin.install('tld')
  end

  def caveats; <<-EOS.undent
    Visit https://github.com/kulp/tenyr for more information on tenyr.
    EOS
  end
end
