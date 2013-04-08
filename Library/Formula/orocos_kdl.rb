require 'formula'

class OrocosKdl < Formula
  homepage 'http://www.orocos.org/kdl'
  url 'http://git.mech.kuleuven.be/?p=robotics/orocos_kinematics_dynamics.git;a=snapshot;h=c8301d2719690703f405ce9a286db897e32a8dca;sf=tgz'
  sha1 ''
  head 'http://git.mech.kuleuven.be/robotics/orocos_kinematics_dynamics.git'
  version '1.1.99'

  depends_on 'cmake' => :build

  def install
    cd 'orocos_kdl' do
      mkdir 'build' do
        system 'pwd'
        system 'cmake', '..', *std_cmake_args
        system 'make'
        system 'make install'
      end
    end
  end
end
