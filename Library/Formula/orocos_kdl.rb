require 'formula'

class OrocosKdl < Formula
  homepage 'http://www.orocos.org/kdl'
  head 'http://git.mech.kuleuven.be/robotics/orocos_kinematics_dynamics.git'
  url 'http://people.mech.kuleuven.be/~rsmits/kdl/orocos-kdl-1.0.2-src.tar.bz2'
  sha1 'dd06fe5bff8dfa1940fc80cd2b2f84ce25bea4e7'
  version '1.0.2'

  if build.head?
    depends_on 'eigen'
  else
    depends_on 'eigen2'
    def patches
      DATA
    end
  end

  depends_on 'cmake' => :build

  def install
    if build.head?
      cd 'orocos_kdl'
    end

    mkdir 'build' do
      system 'cmake', '..', *std_cmake_args
      system 'make'
      system 'make install'
    end
  end
end

__END__
diff --git i/config/FindEigen2.cmake w/config/FindEigen2.cmake
index 0050f19e..4f8313b2 100644
--- i/config/FindEigen2.cmake
+++ w/config/FindEigen2.cmake
@@ -1,4 +1,4 @@
-FIND_PATH(EIGEN2_INCLUDE_DIR Eigen/Core /usr/include /usr/include/eigen2)
+FIND_PATH(EIGEN2_INCLUDE_DIR Eigen/Core /usr/include /usr/include/eigen2 HOMEBREW_PREFIX/opt/eigen2/include/eigen2)
 IF ( EIGEN2_INCLUDE_DIR )
     MESSAGE(STATUS "-- Looking for Eigen2 - found")
     SET(KDL_CFLAGS "${KDL_CFLAGS} -I${EIGEN2_INCLUDE_DIR}" CACHE INTERNAL "")
