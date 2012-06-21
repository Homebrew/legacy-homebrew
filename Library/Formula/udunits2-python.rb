require 'formula'

class Udunits2Python < Formula
  homepage ''
  url 'http://udunits2-python.googlecode.com/files/udunits2-python-1.0.tar.gz'
  sha1 'c75894c7763ae61bdbac86024ac41bfe30520d0f'

  depends_on 'boost' => :build
  depends_on 'udunits'

  def install
    ENV.append('BOOST_MT', 1)
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
netCDF4 Python modules have been linked to:
    #{HOMEBREW_PREFIX}/#{site_package_dir}

Make sure this folder is on your PYTHONPATH.
    EOS
  end
end
