require 'hardware'
require 'extend/ENV/shared'
require 'extend/ENV/std'
require 'extend/ENV/super'

def superenv?
  return false if MacOS::Xcode.without_clt? && MacOS.sdk_path.nil?
  return false unless Superenv.bin && Superenv.bin.directory?
  return false if ARGV.include? "--env=std"
  true
end

module EnvActivation
  def activate_extensions!
    if superenv?
      extend(Superenv)
    else
      extend(Stdenv)
    end
  end
end

ENV.extend(EnvActivation)
