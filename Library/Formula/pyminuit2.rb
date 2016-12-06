require 'formula'

class Pyminuit2 < Formula
  url 'http://pyminuit2.googlecode.com/files/pyminuit2-0.0.1.tar.gz'
  homepage 'http://code.google.com/p/pyminuit2/'
  md5 '9035b9ab03cba2b31ce6f75f37585112'

  depends_on 'minuit2'

  def install

    inreplace 'setup.py' do |s|
      # We're not linking against all of ROOT
      s.gsub! '"Core","Cint","RIO","Net","Hist","Graf","Rint","Matrix","MathCore",', ''
      # Consequently, we don't need to know where ROOT is
      s.gsub! 'library_dirs=[libdir],', ''
      s.gsub! 'include_dirs=[incdir]', ''
    end

    system "python", "setup.py", "install", "--install-lib=#{lib}/python"
  end

  def caveats; <<-EOS
This formula won't function until you amend your PYTHONPATH like so:
    export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/python:$PYTHONPATH
EOS
  end
end
