require 'formula'

class Psycopg2 < Formula
  homepage 'http://initd.org/psycopg'
  url 'http://www.psycopg.org/psycopg/tarballs/PSYCOPG-2-4/psycopg2-2.4.5.tar.gz'
  sha1 '848b2130d948376e1b962faf72f3a2c93dfb5599'

  depends_on 'postgres'

  def install
    system "python setup.py config"
    system "python setup.py build"
    system "python setup.py install --prefix=#{prefix}"
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end

  def site_package_dir
    "lib/#{which_python}/site-packages"
  end

  def caveats
    <<-EOS
psycopg2 Python modules have been linked to:
    #{HOMEBREW_PREFIX}/#{site_package_dir}

Make sure this folder is on your PYTHONPATH.
    EOS
  end
end
