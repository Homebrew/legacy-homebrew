require 'formula'

class BoostJam < Formula
  url 'http://downloads.sourceforge.net/project/boost/boost-jam/3.1.18/boost-jam-3.1.18.tgz'
  homepage 'http://www.boost.org/doc/tools/build/doc/html/jam/usage.html'
  md5 'f790e022d658db38db5cc4aeeccad3f1'

  def install
    if Formula.factory('boost-build-v2').installed?
      ohai 'Boost.Build installed by brew, using it.'
      inreplace [ 'Jambase', 'jambase.c' ], '/usr/share/boost-build', Formula.factory('boost-build-v2').share+'boost-build'
    elsif ENV['BOOST_BUILD_PATH'] and File.exists?(File.join ENV['BOOST_BUILD_PATH'], 'boost-build.jam') or
        ENV['BOOST_PATH'] and File.exists?(File.join ENV['BOOST_PATH'], 'boost-build.jam')
      ohai 'Boost.Build installed manually, using it.'
    elsif File.exists? '/usr/share/boost-build/boost-build.jam'
      ohai 'Boost.Build installed in /usr/share/boost-build, using it.'
    else
      opoo <<-EOS.undent
        Boost.Build not installed. Either install it with
          brew install boost-build-v2
        and reinstall boost-jam, or install Boost.Build manually.
        If not installed to /usr/share/boost-build, set
        BOOST_BUILD_PATH or BOOST_PATH to the installation directory.
      EOS
    end

    system "./build.sh"
    bin.install Dir["bin.macos*/bjam"]
  end
end
