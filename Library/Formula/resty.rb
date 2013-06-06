require 'formula'

class Resty < Formula
  homepage 'https://github.com/micha/resty'
  url 'https://github.com/micha/resty/archive/2.2.tar.gz'
  sha1 'a4dc1b55cee034e72fcf8d58831c734e19f5869a'

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
