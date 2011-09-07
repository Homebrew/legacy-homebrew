require 'formula'

class Resty < Formula
  url 'https://github.com/micha/resty/tarball/2.2'
  homepage 'https://github.com/micha/resty'
  md5 '4f75aee6b65c55eb1e5367fa791430ba'

  head 'https://github.com/micha/resty.git'

  # Don't take +x off these files
  skip_clean 'bin'

  def install
    system "mv README.md README"
    bin.install %w[pp resty pypp]
  end

  def caveats; <<-EOS.undent
    The Python printy-printer (pypp) uses the json module, available in
    Python 2.6 and newer.

    The Perl printy-printer (pp) depends on JSON from CPAN:
      cpan JSON
    EOS
  end
end
