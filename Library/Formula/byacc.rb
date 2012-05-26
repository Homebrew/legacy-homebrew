require 'formula'

class Byacc < Formula
  homepage 'http://invisible-island.net/byacc/byacc.html'
  url 'http://invisible-island.net/datafiles/release/byacc.tar.gz'
  md5 '3061c62c47ec0f43255afd8fc3f7e3ab'
  version '1.9'

  def install

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    # I don't know where the source dir (containing the test/ dir) lives so I don't know how to best execute them
    # It would be 'pushd test; bash run_test.sh; popd;' from there though
    system "true"
  end
end
