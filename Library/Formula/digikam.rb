require 'base_kde_formula'

class Digikam < BaseKdeFormula
  url 'http://downloads.sourceforge.net/project/digikam/digikam/2.6.0-beta1/digikam-2.6.0-beta1.tar.bz2?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fdigikam%2Ffiles%2Fdigikam%2F2.6.0-beta1%2Fdigikam-2.6.0-beta1.tar.bz2%2Fdownload&ts=1330831805&use_mirror=superb-dca2'
  version '2.6.0-beta1'
  homepage 'http://www.digikam.org/'
  #md5 '45e635c0079a608c2d5508be8127d388'

  depends_on 'kdelibs'
  depends_on 'kde-runtime'
  depends_on 'opencv'
  depends_on 'marble'
  depends_on 'libkexiv2'

  def extra_prefix_path
    "#{kdedir}/include/libkexiv2"
  end
end
