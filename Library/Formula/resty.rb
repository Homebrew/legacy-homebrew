require 'formula'

class Resty <Formula
  head 'git://github.com/micha/resty.git'
  homepage 'http://github.com/micha/resty'

  def install
    system "mv README.markdown README"
    bin.install %w[pp resty pypp]
    system "chmod", "a+x", "#{bin}/*"
  end

  def caveats; <<-EOS.undent
    The Python printy-printer (pypp) uses the json module, available in
    Python 2.6 and newer.

    The Perl printy-printer (pp) depends on JSON from CPAN:
      cpan JSON
    EOS
  end
end
