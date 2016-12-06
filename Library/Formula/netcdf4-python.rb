require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Netcdf4Python < Formula
  homepage 'http://code.google.com/p/netcdf4-python/'
  url 'http://netcdf4-python.googlecode.com/files/netCDF4-1.0fix1.tar.gz'
  sha1 'fd80d9445824cd8ad9b0f7bbff8fb5146bf4b2f5'

  depends_on 'hdf5'
  depends_on 'netcdf'

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
netCDF4 Python modules have been linked to:
    #{HOMEBREW_PREFIX}/#{site_package_dir}

Make sure this folder is on your PYTHONPATH.
    EOS
  end
end
