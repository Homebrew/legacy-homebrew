require "hardware"
require "extend/ENV/shared"
require "extend/ENV/std"
require "extend/ENV/super"

def superenv?
  Superenv.bin && ARGV.env != "std"
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
