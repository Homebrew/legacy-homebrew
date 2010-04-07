require 'formula'

class Resty <Formula
  head 'git://github.com/micha/resty.git'
  homepage 'http://github.com/micha/resty'

  def install
    system "mv README.markdown README"
    bin.install %w[pp resty pypp]
  end

  def caveats
    "The Perl printy-printer (pp) depends on JSON from CPAN."
  end
end
