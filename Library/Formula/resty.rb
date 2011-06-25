require 'formula'

class Resty < Formula
  url 'https://github.com/micha/resty/tarball/1.9'
  homepage 'https://github.com/micha/resty'
  md5 'a38223bb0777af3177750dd9d2f49d6d'

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
