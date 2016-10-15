require "formula"

class Qwtpolar < Formula
  homepage "http://qwtpolar.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/qwtpolar/qwtpolar-beta/1.1.0-rc1/qwtpolar-1.1.0-rc1.tar.bz2"
  sha1 "b71d6f462c857fd57f295ad97e87efa88b3b1ada"

  depends_on "qwt"

  def install
    # http://sourceforge.net/p/qwtpolar/bugs/5
    inreplace "examples/examples.pri", "contains(QWT_CONFIG, QwtPolarFramework)", "contains(QWT_POLAR_CONFIG, QwtPolarFramework)"
    inreplace "designer/designer.pro", "contains(QWT_CONFIG, QwtFramework)", "contains(QWT_POLAR_CONFIG, QwtPolarFramework)"

    inreplace "qwtpolarconfig.pri", /QWT_POLAR_INSTALL_PREFIX\s*=.*/, "QWT_POLAR_INSTALL_PREFIX = #{prefix}"

    ENV["QMAKEFEATURES"] = HOMEBREW_PREFIX+"opt/qwt/features"

    system "qmake"
    system "make", "install"
  end
end
