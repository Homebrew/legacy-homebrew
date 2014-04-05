require 'dependency'

# This special dependency ensures that the Tigerbrew ld64
# formula is used as gcc's ld in place of the old version
# that comes with the OS.
class LD64Dependency < Dependency
  def initialize(name='ld64', tags=[:build], env_proc=nil)
    super
    @env_proc = proc { ENV.ld64 }
  end
end
