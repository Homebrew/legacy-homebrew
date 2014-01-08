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

  def with_build_environment
    old_env = to_hash.dup
    tmp_env = to_hash.dup.extend(EnvActivation)
    tmp_env.activate_extensions!
    tmp_env.setup_build_environment
    replace(tmp_env)
    yield
  ensure
    replace(old_env)
  end
end

ENV.extend(EnvActivation)
